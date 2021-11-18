extends Node2D

export(PackedScene) var easy_enemy_scene
enum ENEMY_TYPE{EASY}
export(int) var wave_size = 5
var current_wave = 0
var counter = 0

var is_ready: bool = false

var sum = null
var anim = null
var node = null

var enemy_wave_scene: PackedScene = preload('res://EnemyWaves.tscn')
var enemy_wave_scene_instance: Path2D = null

#I think is_wave_alive should be moved to Enemy_Waves script
func is_wave_alive(current_wave:  Path2D):
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
	if enemy_wave_scene_instance != null:
		if is_wave_alive(enemy_wave_scene_instance) == false:
#			Move the queue_free code to Enemy_Waves script
			enemy_wave_scene_instance.queue_free()
			new_enemy_wave(wave_size, ENEMY_TYPE.EASY)
			add_child(enemy_wave_scene_instance)
		

# Called when the node enters the scene tree for the first time.
func _ready():
	new_enemy_wave(wave_size, ENEMY_TYPE.EASY)
	add_child(enemy_wave_scene_instance)
	

func new_enemy_wave(number_of_enemies, type) -> void:
	match type:
		ENEMY_TYPE.EASY:
			enemy_wave_scene_instance = enemy_wave_scene.instance()
			enemy_wave_scene_instance.transform.origin.y = $Gunner1.position.y - 500
			enemy_wave_scene_instance.transform.origin.x = $Gunner1.position.x +50
			
			enemy_wave_scene_instance.configure(Vector2(0,20), number_of_enemies)			
			enemy_wave_scene_instance.spawn()
	
		
