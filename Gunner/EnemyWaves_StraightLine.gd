extends Path2D
export(PackedScene) var enemy

var wave_vecolity: Vector2 = Vector2.ZERO
var number_of_enemies = 0
var ORIGIN: Vector2 = Vector2(250,70)
var X_GAP = 75

func configure(new_wave_vecolity: Vector2, new_number_of_enemies: int ):
	number_of_enemies = new_number_of_enemies
	wave_vecolity = new_wave_vecolity

func spawn():
	var left_bound = 0
	for i in range(number_of_enemies):
		var enemy_instance: HealthBody2D  = enemy.instance()
		enemy_instance.position = Vector2.ZERO
		$EnemyPath.add_child(enemy_instance)	
		enemy_instance.transform.origin.x = left_bound
		left_bound += X_GAP

# Called when the node enters the scene tree for the first time.
func _ready():
#	Straight Path
	self.curve.add_point(Vector2(0,0), Vector2(0,0), Vector2(800,0))
	self.curve.add_point(Vector2(0,0), Vector2(0,10), Vector2(0,0))

func is_wave_alive():
	pass

func _physics_process(delta):
	$EnemyPath.offset += 1
	self.position.y += wave_vecolity.y

func visible_filter():
	pass
