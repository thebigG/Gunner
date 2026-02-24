extends Node2D

#export var easy_enemy_scene: PackedScene
enum ENEMY_TYPE { EASY, CIRCLE }
var enemy_types = [ENEMY_TYPE.EASY, ENEMY_TYPE.CIRCLE]
@export var wave_size: int = 2
@export var random_waves: bool = true
var current_wave = null
var spwaned_waves = 0.0

var is_ready: bool = false

var enemy_wave_scene_zig_zag: PackedScene = preload("res://scene/EnemyWaves_ZigZag.tscn")

var enemy_wave_scene_circle: PackedScene = preload("res://scene/EnemyWaves_Circle.tscn")
var game_started = false
signal start_game_signal

var health_item_scene: PackedScene = preload("res://scene/HealthItem.tscn")
var shooting_boost_item_scene: PackedScene = preload("res://scene/ShootingBoostItem.tscn")

#Number of waves to clear this level
@export var max_number_of_waves = 10.0
var world_speed = null

var spawn_health = true
var spawn_boost = true
@onready
var easy_stage_background: Sprite2D = get_node("EasyStageScene/EasyStage/ParallaxLayer/Background")

@export var parallax_factor: Vector2 = Vector2(1.00, 1.00)
var camera_node: Camera2D

var level_complete = false


# Called when the node enters the scene tree for the first time.
func _ready():
	world_speed = get_node("EasyStageScene/ParallaxDriver").get("speed")
	self.get_viewport().transient = false
	var help_label = Label.new()
	help_label.text = "Use arrow keys to move. Press the Space Bar to shoot/start the game."
	self.connect("start_game_signal", Callable($EasyStageScene/ParallaxDriver, "start_game"))
	#$EasyStageScene/SoundTrack.connect("finished", $EasyStageScene/SoundTrack.play)
	#$EasyStageScene/SoundTrack.play()
	#screen_size = get_viewport_rect()
	help_label.position.y -= 50
	help_label.global_position.y = get_viewport_rect().size.y / 2 * -1
	$EasyStageScene.add_child(help_label)
	get_tree().paused = false
	randomize()

#	TODO: Figure a way to  initialize easy_stage_material once
	var easy_stage_material: ShaderMaterial = easy_stage_background.material as ShaderMaterial
	camera_node = get_viewport().get_camera_2d()
	if camera_node:
		easy_stage_material.set_shader_parameter("parallax_factor", parallax_factor)


func get_current_level_progress():
	return spwaned_waves / max_number_of_waves


func get_current_level_progress_text():
	return str(spwaned_waves) + "/" + str(max_number_of_waves)


#I think is_wave_alive should be moved to Enemy_Waves script
func is_wave_alive(current_wave: Path2D):
	if current_wave == null:
		return false
	var is_alive = false
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		if is_instance_valid(enemy):
			is_alive = true
			break
	return is_alive


func _physics_process(delta):
	print("*****************************")
	print_orphan_nodes()
	print("*****************************")
	var gunner_position: Vector2 = $Player.get_node("Gunner1").global_position
	if is_instance_valid(current_wave):
		print("enemy_waves[0] position:" + str(current_wave.global_position))
		var distance_to_gunner = current_wave.global_position.distance_to(gunner_position)
		print("position to gunner:" + str(distance_to_gunner))
	#TODO:Need to start thinking about the "progression" in this game.
	if game_started:
		manage_enemy_waves(get_enemy_type(), 2)

		var health_item: CharacterBody2D = manage_health_item()
		if health_item != null:
			health_item.position.y = $Player.get_node("Gunner1").position.y - 1000
			health_item.position.x = get_viewport_rect().size.x / 2
			health_item.set("move_velocity", Vector2(0, world_speed))
			add_child(health_item)
			print("health item")

		var shooting_boost_item: CharacterBody2D = manage_shooting_boost_item()
		if shooting_boost_item != null:
			shooting_boost_item.position.y = $Player.get_node("Gunner1").position.y - 1000
			shooting_boost_item.position.x = get_viewport_rect().size.x / 2
			shooting_boost_item.set("move_velocity", Vector2(0, world_speed))
			add_child(shooting_boost_item)
			print("health item")
		manage_shader_params()


func get_enemy_type():
	var random_enemy_type = enemy_types[randi() % enemy_types.size()]
	return random_enemy_type


func manage_enemies():
	pass


func spawn_enemy_wave(enemy_type, shooting_rate):
	if random_waves:
		wave_size = randi() % 10 + 3
	self.current_wave = new_enemy_wave(wave_size, enemy_type, shooting_rate)
	self.spwaned_waves += 1
	add_child(current_wave)

func manage_enemy_waves(enemy_type, shooting_rate):
	var enemy_y_threshold = get_node("EasyStageScene/ParallaxDriver").position.y
	if current_wave != null and is_instance_valid(current_wave):
		if current_wave.position.y > enemy_y_threshold:
			current_wave.queue_free()
			if spwaned_waves + 1 > max_number_of_waves:
				#Not sure if this is the best way to declare "game over"
				get_node("GameOver").restart_game()
			spawn_enemy_wave(enemy_type, shooting_rate)
	else:
		spawn_enemy_wave(enemy_type, shooting_rate)


func manage_health_item():
	var health_item_chance = randf()
	var new_health_item = null
	if get_current_level_progress() > 0.2 and spawn_health:
		new_health_item = health_item_scene.instantiate()
		spawn_health = false
	return new_health_item


func manage_shooting_boost_item():
	var health_item_chance = randf()
	var new_shooting_boost_item = null
	if get_current_level_progress() > 0.4 and spawn_boost:
		new_shooting_boost_item = shooting_boost_item_scene.instantiate()
		spawn_boost = false
	return new_shooting_boost_item


func manage_shader_params():
	var easy_stage_material: ShaderMaterial = easy_stage_background.material as ShaderMaterial
	if camera_node:
		easy_stage_material.set_shader_parameter("camera_pos", camera_node.global_position)
	if get_current_level_progress() > 0.5:
		easy_stage_material.set_shader_parameter("day_over", true)


func _unhandled_input(input: InputEvent):
	if input.is_action("ui_shoot") and not (game_started):
		self.emit_signal("start_game_signal")
		game_started = true


func new_enemy_wave(number_of_enemies, type, shooting_rate) -> Node:
	var enemy_wave = null
	# path_offset is the "rate" with which the enemies move inside of the wave pattern.
	var path_offset = 5
	match type:
		ENEMY_TYPE.EASY:
			enemy_wave = enemy_wave_scene_zig_zag.instantiate()
			enemy_wave.transform.origin.y = $Player.get_node("Gunner1").position.y - 1000
			enemy_wave.transform.origin.x = (get_viewport_rect().position.x / 2)

#			NOTE:Maybe create a class/struct for configuring the wave...
			enemy_wave.configure(
				Vector2(5, world_speed), number_of_enemies, path_offset, shooting_rate
			)
			enemy_wave.spawn()

		ENEMY_TYPE.CIRCLE:
			enemy_wave = enemy_wave_scene_circle.instantiate()
			enemy_wave.transform.origin.y = $Player.get_node("Gunner1").position.y - 1000
			enemy_wave.transform.origin.x = get_viewport_rect().position.x / 2

			enemy_wave.configure(
				Vector2(5, world_speed), number_of_enemies, path_offset, shooting_rate
			)
			enemy_wave.spawn()
	return enemy_wave
