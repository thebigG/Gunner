extends RigidBody2D
export var velocity = Vector2(0,-100)

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

func _ready():
		pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_Area2D_body_entered(body):
	if body.is_in_group("Enemy"):
#		Play some cool animation
		body.call("destroy")
		queue_free()
				

func _on_Area2D_area_shape_entered(area_id, area, area_shape, local_shape):
	if area_shape.is_in_group("Enemy"):
#		Play some cool animation
		area_shape.call("destroy")
		queue_free()
