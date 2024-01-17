extends Path2D
@export var enemy: PackedScene

var wave_vecolity: Vector2 = Vector2.ZERO
var number_of_enemies = 0
var ORIGIN: Vector2 = Vector2(250, 70)
var X_GAP = 75
var offset = 5
var anim_utils = AnimationUtils.new()
var shooting_rate = 1


# The smaller the path, the faster the enemies traverse the path
func configure(
	new_wave_vecolity: Vector2,
	new_number_of_enemies: int,
	path_offset: int,
	new_shooting_rate: float
):
	number_of_enemies = new_number_of_enemies
	wave_vecolity = new_wave_vecolity
	offset = path_offset
	shooting_rate = new_shooting_rate


func spawn():
	var left_bound = 0
	for i in range(number_of_enemies):
		var enemy_instance: HealthBody2D = enemy.instantiate()
		enemy_instance.position = Vector2.ZERO
		$EnemyPath.add_child(enemy_instance)
		enemy_instance.configure(shooting_rate)
		enemy_instance.transform.origin.x = left_bound
		left_bound += X_GAP


#func circle_pattern():
#	self.curve.add_point(Vector2(0,0), Vector2(0,0),  Vector2(300, 0))
#	self.curve.add_point(Vector2(0,0), Vector2(0,100), Vector2(0, 500))


# Called when the node enters the scene tree for the first time.
func _ready():
# Still learning how the points actually work.
	self.curve.clear_points()
#	TODO: I should make AnimationUtils a singleton
#	anim_utils.zig_zag_pattern(
#		self.curve, anim_utils.zig_zag_pattern(self.curve, Vector2(75, 83), 50, 5), -50, 5
#	)
	anim_utils.circle_pattern(self.curve, Vector2(75, 83), 45, 10, 4)


func is_wave_alive():
	pass


func _physics_process(delta):
	$EnemyPath.progress += offset
	self.position.y += wave_vecolity.y


func visible_filter():
	pass
