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
		left_bound += 75
		get_viewport_rect()
#		position.x = clamp(position.x, 100, screen_size.size.x-24)

# Called when the node enters the scene tree for the first time.
func _ready():
#	Straight Path
	self.curve.add_point(Vector2(0,0), Vector2(0,0), Vector2(800,0))
	self.curve.add_point(Vector2(0,0), Vector2(0,0), Vector2(600,0))
#	self.position = ORIGIN
#	var visibility_filter =  VisibilityNotifier2D.new()
#	visibility_filter.rect = Rect2(0,0, 1000, 20)
#	add_child(visibility_filter)

	#Not sure if this is the best way of doing this...
#	spawn()

func is_wave_alive():
	pass

func _physics_process(delta):
	$EnemyPath.offset += 1
	self.position.y += 0.5

func visible_filter():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
