extends Node2D

#export var easy_enemy_scene: PackedScene
enum ENEMY_TYPE { EASY, CIRCLE }
var enemy_types = [ENEMY_TYPE.EASY, ENEMY_TYPE.CIRCLE]
@export var wave_size: int = 2
var current_wave = 0
var counter = 0

var is_ready: bool = false

var enemy_wave_scene_zig_zag: PackedScene = preload("res://scene/EnemyWaves_ZigZag.tscn")

var enemy_wave_scene_circle: PackedScene = preload("res://scene/EnemyWaves_Circle.tscn")
var enemy_waves = []

var game_started = false
var sound_on = true
signal start_game_signal

var health_item_scene: PackedScene = preload("res://scene/HealthItem.tscn")

var level: PackedScene = preload("res://scene/Level1.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
#	process_mode = Node.PROCESS_MODE_ALWAYS
	self.get_viewport().transient = false
	var help_label = Label.new()
	help_label.text = "Use arrow keys to move. Press the Space Bar to shoot/start the game."
	self.connect("start_game_signal", Callable($EasyStageScene/ParallaxDriver, "start_game"))
	#$EasyStageScene/SoundTrack.play()
	help_label.position.y -= 50
	$EasyStageScene.add_child(help_label)
	get_tree().paused = false
	randomize()


#	enemy_waves.append(new_enemy_wave(wave_size, ENEMY_TYPE.CIRCLE))
#	add_child(enemy_waves[0])


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
				add_child(e)

		var healthb_item: RigidBody2D = manage_health_item()
		if healthb_item != null:
			healthb_item.position.y = $Player.get_node("Gunner1").position.y - 1000
			healthb_item.position.x = get_viewport_rect().size.x / 2
			add_child(healthb_item)
			print("health item")


func get_enemy_type():
	var random_enemy_type = enemy_types[randi() % enemy_types.size()]
	return random_enemy_type


func manage_enemy_waves(node, enemy_type):
	var enemy_y_threshold = get_node("EasyStageScene/ParallaxDriver").position.y

	var new_node = null

	if node != null and is_instance_valid(node):
		if node.position.y > enemy_y_threshold:
			destroy_enemy_wave(node)
			if node != null:
				node.queue_free()
#	if is_wave_alive(node) == false and game_started:
##			Move the queue_free code to Enemy_Waves script
#		if node != null:
#			node.queue_free(

	#Random wave size between 3 and 10
	wave_size = randi() % 10 + 3
	new_node = new_enemy_wave(wave_size, enemy_type)
	print(wave_size)
	return new_node


func manage_health_item():
	var health_item_chance = randf()
	var new_health_item = null
	print("health_item_chance:" + str(health_item_chance))
	if health_item_chance > 0 and health_item_chance < 0.1:
		new_health_item = health_item_scene.instantiate()
	return new_health_item


func _unhandled_input(input: InputEvent):
	if input.is_action("ui_shoot") and not (game_started):
		self.emit_signal("start_game_signal")
		game_started = true


func new_enemy_wave(number_of_enemies, type) -> Node:
	counter += 1
	var enemy_wave = null
	match type:
		ENEMY_TYPE.EASY:
			enemy_wave = enemy_wave_scene_zig_zag.instantiate()
			enemy_wave.transform.origin.y = $Player.get_node("Gunner1").position.y - 1000
			enemy_wave.transform.origin.x = (get_viewport_rect().position.x / 2)

			enemy_wave.configure(Vector2(5, 5), number_of_enemies, 5, 2)
			enemy_wave.spawn()

		ENEMY_TYPE.CIRCLE:
			enemy_wave = enemy_wave_scene_circle.instantiate()
			enemy_wave.transform.origin.y = $Player.get_node("Gunner1").position.y - 1000
			enemy_wave.transform.origin.x = get_viewport_rect().position.x / 2

			enemy_wave.configure(Vector2(5, 0.2), number_of_enemies, 5, 2)
			enemy_wave.spawn()
	return enemy_wave


func destroy_enemy_wave(wave: Path2D):
	for enemy in wave.get_node("EnemyPath").get_children():
		enemy.queue_free()
