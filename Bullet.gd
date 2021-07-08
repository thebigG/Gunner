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
		pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_Area2D_body_entered(body):
#	return
	print('bullet signal')
	if body.is_in_group("Enemy"):
		print("boom!")
#		Play some cool animation
		body.call("destroy")
		queue_free()
				
		
		
	


func _on_Area2D_area_shape_entered(area_id, area, area_shape, local_shape):
	#	return
	print('bullet signal')
	if area_shape.is_in_group("Enemy"):
		print("boom!")
#		Play some cool animation
		area_shape.call("destroy")
		queue_free()
