extends RigidBody2D


export var velocity = Vector2(0,-100)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var shape

class Bullet:
	var position = Vector2()
	var speed = 1.0
	# The body is stored as a RID, which is an "opaque" way to access resources.
	# With large amounts of objects (thousands or more), it can be significantly
	# faster to use RIDs compared to a high-level approach.
	var body = RID()
	func _init():
		pass

func shoot():
	linear_velocity = velocity
# Called when the node enters the scene tree for the first time.


func _ready():
		print("ready...")
#		randomize()
#		shape = Physics2DServer.circle_shape_create()
#		# Set the collision shape's radius for each bullet in pixels.
#		Physics2DServer.shape_set_data(shape, 8)
#		var position = Vector2()
#		var speed = Vector2()
#		# The body is stored as a RID, which is an "opaque" way to access resources.
#		# With large amounts of objects (thousands or more), it can be significantly
#		# faster to use RIDs compared to a high-level approach.
#		var body = RID()
#		var bullet = Bullet.new()
#		# Give each bullet its own speed.
#		bullet.speed = Vector2(0,-100)
#		bullet.body = Physics2DServer.body_create()
#
#		Physics2DServer.body_set_space(bullet.body, get_world_2d().get_space())
#		Physics2DServer.body_add_shape(bullet.body, shape)
#
#		# Place bullets randomly on the viewport and move bullets outside the
#		# play area so that they fade in nicely.
#		bullet.position = Vector2(
#			rand_range(0, get_viewport_rect().size.x) + get_viewport_rect().size.x,
#			rand_range(0, get_viewport_rect().size.y)
#		)
#		var transform2d = Transform2D()
#		transform2d.origin = bullet.position
#		Physics2DServer.body_set_state(bullet.body, Physics2DServer.BODY_STATE_TRANSFORM, transform2d)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
