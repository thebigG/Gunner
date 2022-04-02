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

func circle_pattern():
	self.curve.add_point(Vector2(0,0), Vector2(0,0),  Vector2(300, 0))
	self.curve.add_point(Vector2(0,0), Vector2(0,100), Vector2(0, 500))	

func h_line_pattern():
	self.curve.add_point(Vector2(0,0), Vector2(0,0), Vector2(300, 0))
	self.curve.add_point(Vector2(0,0), Vector2(0,0), Vector2(0, 0))
	
func v_line_pattern():
	self.curve.add_point(Vector2(0,0), Vector2(0,0), Vector2(0, 300))
	self.curve.add_point(Vector2(0,0), Vector2(0,0), Vector2(0, 0))
	
func rectangle_pattern(origin: Vector2, width: int, height: int):
	self.curve.add_point(origin, Vector2(0,0), Vector2(0,0))
	self.curve.add_point(Vector2(origin.x + width, origin.y), 
						Vector2(0,0), 
						Vector2(0, 0))
	self.curve.add_point(Vector2(origin.x+width, origin.y + height), 
						Vector2(0,0), 
						Vector2(0,0))
	self.curve.add_point(Vector2(origin.x, origin.y + height), 
						Vector2(0,0), 
						Vector2(0,0))
	self.curve.add_point(origin, 
						 Vector2(0,0), 
						 Vector2(0,0))
		
# Called when the node enters the scene tree for the first time.
func _ready():
# Still learning how the points actually work.
	self.curve.clear_points()	
	rectangle_pattern(Vector2(75, 83), 50, 50)

func is_wave_alive():
	pass

func _physics_process(delta):
	$EnemyPath.offset += offset
	self.position.y += wave_vecolity.y

func visible_filter():
	pass
