extends Node2D

#export var easy_enemy_scene: PackedScene
enum ENEMY_TYPE { EASY, CIRCLE }
@export var wave_size: int = 5
var current_wave = 0
var counter = 0

var is_ready: bool = false

var enemy_wave_scene_zig_zag: PackedScene = preload("res://scene/EnemyWaves_ZigZag.tscn")
var enemy_wave_scene_zig_zag_instance: Path2D = null

var enemy_wave_scene_circle: PackedScene = preload("res://scene/EnemyWaves_Circle.tscn")
var enemy_wave_scene_circle_instance: Path2D = null

var game_started = false
signal start_game_signal


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
	var enemy_y_threshold = get_node("EasyStageScene/ParallaxDriver").position.y
	if enemy_wave_scene_zig_zag_instance != null and is_instance_valid(enemy_wave_scene_zig_zag):
		if enemy_wave_scene_zig_zag_instance.position.y > enemy_y_threshold:
			destroy_enemy_wave(enemy_wave_scene_zig_zag_instance)
	if is_wave_alive(enemy_wave_scene_zig_zag_instance) == false and game_started:
#			Move the queue_free code to Enemy_Waves script
		if enemy_wave_scene_zig_zag_instance != null:
			enemy_wave_scene_zig_zag_instance.queue_free()
		new_enemy_wave(wave_size, ENEMY_TYPE.EASY)
		new_enemy_wave(wave_size, ENEMY_TYPE.CIRCLE)
		add_child(enemy_wave_scene_zig_zag_instance)
		add_child(enemy_wave_scene_circle_instance)


#	if enemy_wave_scene_circle_instance != null and is_instance_valid(enemy_wave_scene_circle_instance):
#		print(enemy_wave_scene_circle_instance.position)


# Called when the node enters the scene tree for the first time.
func _ready():
#	process_mode = Node.PROCESS_MODE_ALWAYS
	self.get_viewport().transient = false
	var help_label = Label.new()
	help_label.text = "Use arrow keys to move. Press the Space Bar to shoot/start the game."
	self.connect("start_game_signal", Callable($EasyStageScene/ParallaxDriver, "start_game"))
#	$EasyStageScene/SoundTrack.play()
	help_label.position.y -= 50
	$EasyStageScene.add_child(help_label)
	get_tree().paused = false


#	for child in get_children():
#		child.process_mode = Node.PROCESS_MODE_PAUSABLE


func _unhandled_input(input: InputEvent):
	if input.is_action("ui_shoot") and not (game_started):
		self.emit_signal("start_game_signal")
		game_started = true


func new_enemy_wave(number_of_enemies, type) -> void:
	counter += 1
	match type:
		ENEMY_TYPE.EASY:
			enemy_wave_scene_zig_zag_instance = enemy_wave_scene_zig_zag.instantiate()
			enemy_wave_scene_zig_zag_instance.transform.origin.y = $Gunner1.position.y - 1000
			enemy_wave_scene_zig_zag_instance.transform.origin.x = (
				get_viewport_rect().position.x / 2
			)

			enemy_wave_scene_zig_zag_instance.configure(Vector2(5, 1), number_of_enemies, 5, 5)
			enemy_wave_scene_zig_zag_instance.spawn()

		ENEMY_TYPE.CIRCLE:
			enemy_wave_scene_circle_instance = enemy_wave_scene_circle.instantiate()
			enemy_wave_scene_circle_instance.transform.origin.y = $Gunner1.position.y - 1000
			enemy_wave_scene_circle_instance.transform.origin.x = get_viewport_rect().position.x / 2

			enemy_wave_scene_circle_instance.configure(Vector2(5, 1), 1, 5, 5)
			enemy_wave_scene_circle_instance.spawn()


func destroy_enemy_wave(wave: Path2D):
	for enemy in wave.get_node("EnemyPath").get_children():
		enemy.queue_free()
