extends Node2D

#export var easy_enemy_scene: PackedScene
enum ENEMY_TYPE { EASY, CIRCLE }
var enemy_types = [ENEMY_TYPE.EASY, ENEMY_TYPE.CIRCLE]
@export var wave_size: int = 2
var current_wave = 0
var spwaned_waves = 0.0

var is_ready: bool = false

var enemy_wave_scene_zig_zag: PackedScene = preload("res://scene/EnemyWaves_ZigZag.tscn")

var enemy_wave_scene_circle: PackedScene = preload("res://scene/EnemyWaves_Circle.tscn")
var enemy_waves = []

var game_started = false
signal start_game_signal

var health_item_scene: PackedScene = preload("res://scene/HealthItem.tscn")
var shooting_boost_item_scene: PackedScene = preload("res://scene/ShootingBoostItem.tscn")

#Number of waves to clear this level
var max_number_of_waves = 10.0
var world_speed = null

var spawn_health = true
var spawn_boost = true


# Called when the node enters the scene tree for the first time.
func _ready():
	world_speed = get_node("EasyStageScene/ParallaxDriver").get("speed")
#	process_mode = Node.PROCESS_MODE_ALWAYS
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


func get_current_level_progress():
	return spwaned_waves / max_number_of_waves


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
	var gunner_position: Vector2 = $Player.get_node("Gunner1").global_position

	if len(enemy_waves) > 0 and is_instance_valid(enemy_waves[0]):
		print("enemy_waves[0] position:" + str(enemy_waves[0].global_position))
		var distance_to_gunner = enemy_waves[0].global_position.distance_to(gunner_position)
		#if distance_to_gunner < 300:
		#enemy_waves[0].set(
		#"velocity", Vector2(5, get_node("EasyStageScene/ParallaxDriver").get("speed") * -1)
		#)
		#else:
		#enemy_waves[0].set("velocity", Vector2(5, 2))
		print("position to gunner:" + str(distance_to_gunner))
	#TODO:Need to start thinking about the "progression" in this game.
	if game_started:
		var new_waves = []
		var i = 0
		var max_waves = 1  # Could be part of the progression of the game
		while i < (max_waves):
			var temp = []
			if len(enemy_waves) > 0:
				temp.append(manage_enemy_waves(enemy_waves[i], get_enemy_type()))
			else:
				temp.append(manage_enemy_waves(null, get_enemy_type()))
			new_waves.append_array(temp)
			i += 1
		i = 0
		var enemy_waves_len = len(enemy_waves)
		if len(enemy_waves) > 0:
			while i < enemy_waves_len:
				if not (is_instance_valid(enemy_waves[i])):
					enemy_waves.remove_at(enemy_waves.find(enemy_waves[i]))
					enemy_waves_len = len(enemy_waves)
				i += 1
		if len(new_waves) > 0 and len(enemy_waves) < max_waves:
			enemy_waves.append_array(new_waves)
			for e in enemy_waves:
				spwaned_waves += 1
				add_child(e)

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


func get_enemy_type():
	var random_enemy_type = enemy_types[randi() % enemy_types.size()]
	return random_enemy_type


func manage_enemy_waves(node, enemy_type):
	var enemy_y_threshold = get_node("EasyStageScene/ParallaxDriver").position.y

	var new_node = null

	if node != null and is_instance_valid(node):
		if node.position.y > enemy_y_threshold:
			if node != null:
				node.queue_free()

	#Random wave size between 3 and 10
	wave_size = randi() % 10 + 3
	new_node = new_enemy_wave(wave_size, enemy_type)

	if spwaned_waves > max_number_of_waves:
		get_node("GameOver").restart_game()

	print(wave_size)
	return new_node


func manage_health_item():
	var health_item_chance = randf()
	var new_health_item = null
	if get_current_level_progress() > 0.2 and spawn_health:
		#if health_item_chance > 0 and health_item_chance < 0.1:
		new_health_item = health_item_scene.instantiate()
		spawn_health = false
	return new_health_item


func manage_shooting_boost_item():
	var health_item_chance = randf()
	var new_shooting_boost_item = null
	if get_current_level_progress() > 0.4 and spawn_boost:
		#if health_item_chance > 0 and health_item_chance < 0.1:
		new_shooting_boost_item = shooting_boost_item_scene.instantiate()
		spawn_boost = false
	return new_shooting_boost_item


func _unhandled_input(input: InputEvent):
	if input.is_action("ui_shoot") and not (game_started):
		self.emit_signal("start_game_signal")
		game_started = true


func new_enemy_wave(number_of_enemies, type) -> Node:
	var enemy_wave = null
	match type:
		ENEMY_TYPE.EASY:
			enemy_wave = enemy_wave_scene_zig_zag.instantiate()
			enemy_wave.transform.origin.y = $Player.get_node("Gunner1").position.y - 1000
			enemy_wave.transform.origin.x = (get_viewport_rect().position.x / 2)

			enemy_wave.configure(Vector2(5, world_speed), number_of_enemies, 5, 2)
			enemy_wave.spawn()

		ENEMY_TYPE.CIRCLE:
			enemy_wave = enemy_wave_scene_circle.instantiate()
			enemy_wave.transform.origin.y = $Player.get_node("Gunner1").position.y - 1000
			enemy_wave.transform.origin.x = get_viewport_rect().position.x / 2

			enemy_wave.configure(Vector2(5, world_speed), number_of_enemies, 5, 2)
			enemy_wave.spawn()
	return enemy_wave
