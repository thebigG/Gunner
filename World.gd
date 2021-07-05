extends Node2D

export(PackedScene) var enemy_scene

func current_wave_alive():
	return true

func _physics_process(delta):
	if not(current_wave_alive()):
		var new_enemies = new_enemy_wave(5)
		for enemy in new_enemies:
			add_child(enemy)
		 

# Called when the node enters the scene tree for the first time.
func _ready():
	var new_enemies = new_enemy_wave(3)
	simple_enemy_line(new_enemies)
	for enemy in new_enemies:
		add_child(enemy)
		 
		
func simple_enemy_line(wave):
	var left_bound = wave[0].transform.origin.x
	for enemy in wave:
		enemy.transform.origin.y = $Gunner1.position.y - 200
		enemy.transform.origin.x = left_bound
		left_bound += 100
		enemy.linear_velocity.y = 100

func new_enemy_wave(number_of_enemies):
	var out_enemies = []
	for i in range(number_of_enemies):
		out_enemies.append(enemy_scene.instance())
	
	return out_enemies
		
