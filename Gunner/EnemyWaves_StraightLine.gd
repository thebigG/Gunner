extends Path2D
export(PackedScene) var enemy

var wave_vecolity: Vector2 = Vector2.ZERO
var number_of_enemies = 0
var ORIGIN: Vector2 = Vector2(250,70)
var X_GAP = 75
var offset = 5

# The smaller the path, the faster the enemies traverse the path
func configure(new_wave_vecolity: Vector2, new_number_of_enemies: int, path_offset: int):
	number_of_enemies = new_number_of_enemies
	wave_vecolity = new_wave_vecolity
	offset = path_offset

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
# Still learning how the points actually work.
	self.curve.clear_points()
	self.curve.add_point(Vector2(0,0), Vector2(0,0), Vector2(0, 80))
	self.curve.add_point(Vector2(0,0), Vector2(0,0), Vector2(0, 0), self.curve.get_point_count()-2)
#	$EnemyPath.position = Vector2(249.286, 69.558)
	

func is_wave_alive():
	pass

func _physics_process(delta):
	$EnemyPath.offset += offset
	self.position.y += wave_vecolity.y

func visible_filter():
	pass
