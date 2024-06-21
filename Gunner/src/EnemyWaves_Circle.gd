extends CharacterBody2D
@export var enemy: PackedScene

var wave_velocity: Vector2 = Vector2.ZERO
var number_of_enemies = 0
var ORIGIN: Vector2 = Vector2(250, 70)
var X_GAP = 75
var offset = 100
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
	self.position.x += 100
	var left_bound = 0
	for i in range(number_of_enemies):
		var enemy_instance: HealthBody2D = enemy.instantiate()
		enemy_instance.position = Vector2.ZERO
		$Enemy_Circle/EnemyPath.add_child(enemy_instance)
		enemy_instance.configure(shooting_rate)
		enemy_instance.position.x = left_bound
		left_bound += X_GAP

	var current_pos = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
# Still learning how the points actually work.
	$Enemy_Circle.curve.clear_points()
#	TODO: I should make AnimationUtils a singleton
#	anim_utils.zig_zag_pattern(
#		self.curve, anim_utils.zig_zag_pattern(self.curve, Vector2(75, 83), 50, 5), -50, 5
#	)
#	anim_utils.circle_pattern(self.curve, Vector2(75, 83), 45, 10, 4)
	var points = get_full_circle_shape_2dvectors_1phase(75, 75, Vector2(75, 0))
	for p in points:
		$Enemy_Circle.curve.add_point(p)


func get_full_circle_shape_2dvectors_1phase(
	x_radius: float, y_radius: float, origin: Vector2
) -> Array:
#	TODO:I think it's a matter of getting the all the points while the radius has not been covered?? Or going from o to 360n degrees.
	var points = [origin]
	var i = 0
	var current_sin_input_val = 0
	var current_cos_input_val = 0
	var x_speed: float = 0.05  #radians/spped/rate
	var y_speed: float = 0.05  #radians/spped/rate

#	Possible implementation...not quite right
	while i < 1 * (2 * PI):
#		Need to come up with all values for sin
#		Need to come up with all values for cos
		var temp_current_sinusoidal_output_val = y_radius * sin(current_sin_input_val)
		var temp_current_cos_output_val = x_radius * cos(current_cos_input_val)
		points.append(Vector2(temp_current_cos_output_val, temp_current_sinusoidal_output_val))
		current_sin_input_val += y_speed
		current_cos_input_val += x_speed
		if y_speed < x_speed:
			i += y_speed
		else:
			i += x_speed
	return points


func is_wave_alive():
	pass


func _physics_process(delta):
	$Enemy_Circle/EnemyPath.progress += offset
	move_and_slide()


func visible_filter():
	pass
