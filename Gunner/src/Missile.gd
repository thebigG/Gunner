extends RigidBody2D
@export var velocity = Vector2(0, -100)
var target_group: String = ""

signal hit_signal

var triggered = false
var time_after_trigger = 0.5

var trigger_timer: Timer = Timer.new()


func shoot(velocity: Vector2):
	linear_velocity = velocity


func _ready():
	$Area2D.connect("body_entered", Callable(self, "_on_Area2D_body_entered"))
	$VisibleOnScreenNotifier2D.connect("screen_exited", Callable(self, "queue_free"))
	#	self.add_to_group("Gunner_Bullet")
	self.add_child(trigger_timer)


func configure(new_target_group: String):
	target_group = new_target_group


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func destroy_enemies_in_radius():
	var enemies = $Area2D.get_overlapping_bodies()
	for enemy in enemies:
		if enemy.is_in_group("Enemy"):
			#		Play some cool animation
			#TODO:Collect nodes for 0.5 secs/or some amount of time and then trigger
			#explosion for each node collected
			print("body:")
			enemy.call("damage")
			emit_signal("hit_signal")
			#print("bodies:" + str(len($Area2D.get_overlapping_bodies())))
			#$Area2D/CollisionShape2D
	queue_free()


func _on_Area2D_body_entered(body):
	#Expand damage radius when we hit enemy.
	if body.is_in_group("Enemy") and not (triggered):
		trigger_timer.wait_time = time_after_trigger
		trigger_timer.timeout.connect(Callable(self, "destroy_enemies_in_radius"))
		trigger_timer.autostart = true
		trigger_timer.paused = false
		triggered = true
	##		Play some cool animation
	##TODO:Collect nodes for 0.5 secs/or some amount of time and then trigger
	##explosion for each node collected
