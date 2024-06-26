extends RigidBody2D
@export var velocity = Vector2(0, -100)
var target_group: String = ""

signal hit_signal


func shoot(velocity: Vector2):
	linear_velocity = velocity


func _ready():
	$Area2D.connect("body_entered", Callable(self, "_on_Area2D_body_entered"))
#	self.connect("body_entered", Callable(self, "_on_Area2D_body_entered"))
#I case we want collisions triggered from RigidBody2D, the following fields need to be set
#	self.contact_monitor = true
#	self.max_contacts_reported = 8
	self.add_to_group("Gunner_Bullet")
	$VisibleOnScreenNotifier2D.connect("screen_exited", Callable(self, "queue_free"))


func configure(new_target_group: String):
	target_group = new_target_group


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_Area2D_body_entered(body):
	print("_on_Area2D_body_entered")
	if body.is_in_group("Enemy"):
#		Play some cool animation
		body.call("damage")
		emit_signal("hit_signal")
		queue_free()
