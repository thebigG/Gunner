extends Path2D

export(PackedScene) var enemy
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var wave_vecolity = 0
var number_of_enemies = 0
var ORIGIN: Vector2 = Vector2(250,70)

func configure(new_wave_vecolity: Vector2, new_number_of_enemies: int):
	number_of_enemies = new_number_of_enemies
	wave_vecolity = new_wave_vecolity

func spawn():
	var left_bound = 0
	for i in range(number_of_enemies):
		var enemy_instance  = enemy.instance()
		enemy_instance.position = Vector2.ZERO
		$EnemyPath.add_child(enemy_instance)	
		enemy_instance.transform.origin.x = left_bound
#		enemy_instance.linear_velocity = wave_vecolity
		left_bound += 75
#		enemy.linear_velocity.y = 10

# Called when the node enters the scene tree for the first time.
func _ready():
#	Straight Path
	self.curve.add_point(Vector2(0,0), Vector2(0,0), Vector2(800,0))
	self.curve.add_point(Vector2(0,0), Vector2(0,0), Vector2(600,0))
	self.position = ORIGIN
	print('point count'  + str(self.curve.get_point_count()))
	#Not sure if this is the best way of doing this...
	configure(Vector2(50,0), 3)
	spawn()

func is_wave_alive():
	pass

func _physics_process(delta):
	$EnemyPath.offset += 1
	self.position.y += 0.5
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
