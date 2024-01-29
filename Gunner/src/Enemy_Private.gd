extends HealthBody2D

@export var bullet_scene: PackedScene

var shoot_bullet_timer: Timer = Timer.new()
var shooting_rate = 10  # Hertz

var time = 0

#var bullet: RigidBody2D = bullet_scene.instantiate()
# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D.connect("body_entered", Callable(self, "damage_gunner"))
	print("enemy ready")
#	shoot_bullet_timer.wait_time = 1 / shooting_rate
#	shoot_bullet_timer.timeout.connect(Callable(self, "shoot_gunner"))
#	shoot_bullet_timer.autostart = true
#	shoot_bullet_timer.paused = false
#	shoot_bullet_timer.process_callback = Timer.TIMER_PROCESS_PHYSICS
	self.damage_interval = 1.0
#TODO:Remove velocity. Here for debug purposes only
	velocity = Vector2(0,100)
#	add_child(shoot_bullet_timer)


func print_func(arg: Node):
	print("Arg:" + str(arg))


func _physics_process(delta):
	print("position:" + str(self.position))
	move_and_slide()
	time += delta

#	if Input.is_action_pressed("ui_shoot"):
	var calculated_rate_k = Engine.physics_ticks_per_second / shooting_rate
	if time >= delta * calculated_rate_k:
		time = 0
		print("Shoot")
#		var new_bullet = bullet_scene.instantiate()
#		#		connect(signal: String,Callable(target: Object,method: String).bind(binds: Array = [  ),flags: int = 0)
#
##		new_bullet.connect("hit_signal", Callable(self, "increment_score"))
#		add_child(new_bullet)
#		$Shoot.play()
#		new_bullet.shoot()
		
		shoot_gunner()

	
	
	
	match self.state:
#		HealthBody2D.DEAD
		2:
			queue_free()
			var boom = get_tree().get_nodes_in_group("World3D")[0].get_node("Boom")
			boom.play()


# When using HealthBody2D as type hint, I get the following error:
# Error calling from signal 'body_entered' to callable: 'HealthBody2D(Enemy_Private.gd)::damage_gunner': Cannot convert argument 1 from Object to Object.
#That error is by design:https://github.com/thebigG/Gunner/issues/19
func damage_gunner(gunner: Node2D):
	print("damage_gunner")
	if is_instance_valid(gunner) and gunner.is_in_group("Gunner"):
		gunner.damage()


func _exit_tree():
	pass


func shoot_gunner():
	print("Shoot Gunner")
	var bullet = bullet_scene.instantiate()
	bullet.position = self.position 
	add_child(bullet)
	bullet.shoot(Vector2(0, 100))


func _on_Boom_finished():
	pass


func configure(new_shooting_rate):
	shooting_rate = new_shooting_rate


func _on_VisibilityNotifier2D_viewport_exited(viewport):
	pass
#	queue_free()
#	shoot_bullet_timer.queue_free()
