extends RigidBody2D
var target_group: String = ""


func shoot(velocity):
	linear_velocity = velocity


func _ready():
	$Area2D.connect("body_entered",Callable(self,"_on_Area2D_body_entered"))
	#TODO:Use ratios instead of hard-coded values here...
	position.x = -20
	position.y = 20


func configure(new_target_group: String):
	target_group = new_target_group


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	print("Enemy Bullet position:" + str(position))
	pass


func _on_Area2D_body_entered(body):
	if body.is_in_group("Gunner"):
#		Play some cool animation
		body.call("damage")
		queue_free()
	elif body.is_in_group("Gunner_Bullet"):
		body.call("queue_free")
		queue_free()
