extends Node2D

#export(PackedScene) var easy_enemy_scene
enum ENEMY_TYPE{EASY}
export(int) var wave_size = 5
var current_wave = 0
var counter = 0

var is_ready: bool = false

var sum = null
var anim = null
var node = null

var enemy_wave_scene: PackedScene = preload('res://scene/EnemyWaves.tscn')
var enemy_wave_scene_instance: Path2D = null
var game_started = false
signal start_game_signal

#I think is_wave_alive should be moved to Enemy_Waves script
func is_wave_alive(current_wave:  Path2D):
	if enemy_wave_scene_instance == null:
		return false
	var is_alive = false
	for enemy in get_tree().get_nodes_in_group("Enemy"):
#		print('is enemy alive??')
		if(is_instance_valid(enemy)):
			is_alive = true
			break		
	return is_alive

#func destroy_wave(wave):
#	for enemy in wave:
#		enemy.call('destroy')

func _physics_process(delta):
		if is_wave_alive(enemy_wave_scene_instance) == false and game_started:
#			Move the queue_free code to Enemy_Waves script
			enemy_wave_scene_instance.queue_free()
			new_enemy_wave(wave_size, ENEMY_TYPE.EASY)
			add_child(enemy_wave_scene_instance)

# Called when the node enters the scene tree for the first time.
func _ready():
#	pause_mode = Node.PAUSE_MODE_PROCESS
	var help_label = Label.new()
	help_label.text = "Use arrow keys to move. Press the Space Bar to shoot/start the game."
	self.connect("start_game_signal", $EasyStageScene/ParallaxDriver, "start_game")
	enemy_wave_scene_instance = enemy_wave_scene.instance()
	new_enemy_wave(wave_size, ENEMY_TYPE.EASY)
	add_child(enemy_wave_scene_instance)
#	$EasyStageScene/SoundTrack.play()
	$EasyStageScene.add_child(help_label)
	for child in get_children():
		child.pause_mode = Node.PAUSE_MODE_STOP

func _unhandled_input(input: InputEvent):
	if input.is_action("ui_accept") and not(game_started):
		self.emit_signal("start_game_signal")
		game_started = true
	if input.is_action("ui_pause"):
		get_tree().paused = false if get_tree().paused else true

func new_enemy_wave(number_of_enemies, type) -> void:
	counter += 1
	match type:
		ENEMY_TYPE.EASY:
			enemy_wave_scene_instance = enemy_wave_scene.instance()
			enemy_wave_scene_instance.transform.origin.y = $Gunner1.position.y - 1000
			enemy_wave_scene_instance.transform.origin.x = get_viewport_rect().position.x/2
			
			enemy_wave_scene_instance.configure(Vector2(5,1), number_of_enemies, 2)			
			enemy_wave_scene_instance.spawn()
