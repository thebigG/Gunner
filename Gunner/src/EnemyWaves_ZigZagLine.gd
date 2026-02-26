extends CharacterBody2D
@export var enemy: PackedScene

var wave_velocity: Vector2 = Vector2.ZERO
var number_of_enemies = 0
var ORIGIN: Vector2 = Vector2(250, 70)
var X_GAP = 75
var offset = 5
var anim_utils = AnimationUtils.new()
var shooting_rate = 1


# The smaller the path, the faster the enemies traverse the path
func configure(
	new_wave_velocity: Vector2,
	new_number_of_enemies: int,
	path_offset: int,
	new_shooting_rate: float
):
	number_of_enemies = new_number_of_enemies
	wave_velocity = new_wave_velocity
	offset = path_offset
	shooting_rate = new_shooting_rate
	self.velocity = wave_velocity


func spawn():
	var left_bound = 0
	for i in range(number_of_enemies):
		var enemy_instance: Node = enemy.instantiate()
		enemy_instance.get_node("EasyEnemyHealthBody2D").position = Vector2.ZERO
		$Enemy_ZigZagLine/EnemyPath.add_child(enemy_instance)
		enemy_instance.get_node("EasyEnemyHealthBody2D").configure(shooting_rate)
		enemy_instance.get_node("EasyEnemyHealthBody2D").transform.origin.x = left_bound
		left_bound += X_GAP


#	for i in range(self.curve.point_count):
#		print(self.curve.get_point_position(i))

#func circle_pattern():
#	self.curve.add_point(Vector2(0,0), Vector2(0,0),  Vector2(300, 0))
#	self.curve.add_point(Vector2(0,0), Vector2(0,100), Vector2(0, 500))


func _exit_tree():
	print("break")
	anim_utils.queue_free()


# Called when the node enters the scene tree for the first time.
func _ready():
# Still learning how the points actually work.
	$Enemy_ZigZagLine.curve.clear_points()
#	TODO: I should make AnimationUtils a singleton
#	AnimationUtils.new().h_line_pattern(self.curve, Vector2(75, 83), 50)
#	AnimationUtils.new().rectangle_pattern(self.curve, Vector2(75, 83), 50, 100)
#	AnimationUtils.new().zig_zag_pattern(Vector2(75, 83), 50, 5)
	anim_utils.zig_zag_pattern(
		$Enemy_ZigZagLine.curve,
		anim_utils.zig_zag_pattern($Enemy_ZigZagLine.curve, Vector2(75, 83), 50, 5),
		-50,
		5
	)


#	anim_utils.zig_zag_pattern(self.curve, Vector2(25, 83), 50, 5), -50, 5
#	anim_utils.zig_zag_pattern(self.curve, Vector2(25, 83), 50, 5)


func is_wave_alive():
	pass


func _physics_process(delta):
	$Enemy_ZigZagLine/EnemyPath.progress += offset
	move_and_slide()


func visible_filter():
	pass
