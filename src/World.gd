extends Node2D

export(PackedScene) var easy_enemy_scene
enum ENEMY_TYPE{EASY}
export(int) var wave_size = 5
var current_wave = 0
var counter = 0

func is_wave_alive(current_wave):
	var is_alive = false
	for enemy in current_wave:
		if(is_instance_valid(enemy)):
			is_alive = true
			break		
	return is_alive

func destroy_wave(wave):
	print('destroy_wave')
	for enemy in wave:
		enemy.call('destroy')

func _physics_process(delta):
	if counter==0:
		if is_wave_alive(current_wave) == false:
#			counter += 1
#			print('new wave')
			var new_enemies = new_enemy_wave(wave_size, ENEMY_TYPE.EASY)
			simple_enemy_line(new_enemies)
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
	if !wave.empty():
		var left_bound = wave[0].transform.origin.x + 100
		for enemy in wave:
			enemy.transform.origin.y = $Gunner1.position.y - 500
			enemy.transform.origin.x = left_bound
			left_bound += 100
			enemy.linear_velocity.y = 10

func new_enemy_wave(number_of_enemies, type):
	var out_enemies = []
	match type:
		ENEMY_TYPE.EASY:		
			for i in range(number_of_enemies):
				out_enemies.append(easy_enemy_scene.instance())
	
	return out_enemies
		
