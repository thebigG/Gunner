extends Path2D

export(PackedScene) var enemy
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var wave_speed = 0
var number_of_enemies = 0

func configure(new_wave_speed, new_number_of_enemies):
	number_of_enemies = new_number_of_enemies

func spawn():
	var left_bound = 0
	for i in range(number_of_enemies):
		$EnemyPath.add_child(enemy.instance())	
		enemy.transform.origin.x = left_bound
		left_bound += 10
#		enemy.linear_velocity.y = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	#Not sure if this is the best way of doing this...
	spawn()

func is_wave_alive():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
