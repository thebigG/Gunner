extends HealthBody2D

@export var bullet_scene: PackedScene

var shoot_bullet_timer: Timer = Timer.new()


#var bullet: RigidBody2D = bullet_scene.instantiate()
# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D.connect("body_entered", Callable(self, "damage_gunner"))
	print("enemy ready")
	shoot_bullet_timer.wait_time = 1
	shoot_bullet_timer.timeout.connect(Callable(self, "shoot_gunner"))
#	shoot_bullet_timer.connect("timeout",Callable(self,"shoot_gunner"))
#	shoot_bullet_timer.process_callback = Timer.TIMER_PROCESS_PHYSICS
#	shoot_bullet_timer.start(2)
	shoot_bullet_timer.autostart = true
	shoot_bullet_timer.paused = false
	add_child(shoot_bullet_timer)


func _physics_process(delta):
	match self.state:
#		HealthBody2D.DEAD
		2:
			queue_free()
			var boom = get_tree().get_nodes_in_group("World3D")[0].get_node("Boom")
			boom.play()


func damage_gunner(gunner: HealthBody2D):
	if is_instance_valid(gunner) and gunner.is_in_group("Gunner"):
		gunner.damage()


func _exit_tree():
	pass


func shoot_gunner():
	print("Shoot Gunner")
	var bullet = bullet_scene.instantiate()
	add_child(bullet)
	bullet.shoot(Vector2(0, 500))


func _on_Boom_finished():
	pass


func _on_VisibilityNotifier2D_viewport_exited(viewport):
	pass
#	queue_free()
#	shoot_bullet_timer.queue_free()
