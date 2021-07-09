extends Node2D

export(PackedScene) var easy_enemy_scene
enum ENEMY_TYPE{EASY}
export(int) var wave_size = 5
var current_wave = 0

func is_in_camera_view(node):
	return node.position.y < $Gunner1/Camera2D.get_camera_position().y 

func is_wave_alive(current_wave):
	var is_alive = true
	for enemy in current_wave:
		if(not(is_in_camera_view(enemy))):
			is_alive = false
			print('false')
			break		
	return is_alive

func destroy_wave(wave):
	for enemy in wave:
		enemy.queue_free()

func _physics_process(delta):
	if is_wave_alive(current_wave) == false:
		destroy_wave(current_wave)
		print('new eave')
		var new_enemies = new_enemy_wave(wave_size, ENEMY_TYPE.EASY)
		for enemy in new_enemies:
			add_child(enemy)
		current_wave = new_enemies
		 

# Called when the node enters the scene tree for the first time.
func _ready():
	print("ready")
	var new_enemies = new_enemy_wave(wave_size, ENEMY_TYPE.EASY)
	simple_enemy_line(new_enemies)
	for enemy in new_enemies:
		add_child(enemy)
	current_wave = new_enemies 
	print("current_wave" + str(current_wave))
		
func simple_enemy_line(wave):
	var left_bound = wave[0].transform.origin.x + 25
	for enemy in wave:
		enemy.transform.origin.y = $Gunner1.position.y - 200
		enemy.transform.origin.x = left_bound
		left_bound += 100
		enemy.linear_velocity.y = 100

func new_enemy_wave(number_of_enemies, type):
	var out_enemies = []
	match type:
		ENEMY_TYPE.EASY:		
			for i in range(number_of_enemies):
				out_enemies.append(easy_enemy_scene.instance())
	
	return out_enemies
		
