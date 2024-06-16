extends HealthBody2D

@export var bullet_scene: PackedScene

var shoot_bullet_timer: Timer = Timer.new()
var shooting_rate = 1  # Hertz
var info_label = Label.new()

var explosion_particles: PackedScene = preload("res://scene/Explosion.tscn")
var explosion: Node2D


#var bullet: RigidBody2D = bullet_scene.instantiate()
# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D.connect("body_entered", Callable(self, "damage_gunner"))
	print("enemy ready")
	shoot_bullet_timer.wait_time = 1 / shooting_rate
	shoot_bullet_timer.timeout.connect(Callable(self, "shoot_gunner"))
	shoot_bullet_timer.autostart = true
	shoot_bullet_timer.paused = false
	self.damage_interval = 1.0

	explosion = explosion_particles.instantiate()
	var particles: GPUParticles2D = explosion.get_node("ExplosionParticles")
	particles.emitting = false
	particles.one_shot = true
	particles.connect("finished", Callable(self, "after_explosion"))
	add_child(explosion)

	add_child(shoot_bullet_timer)
	add_child(info_label)


func print_func(arg: Node):
	print("Arg:" + str(arg))


func after_explosion():
	queue_free()


func _physics_process(delta):
	#TODO:Not sure why this rotation is offset by 90 degrees...
	self.rotation = (
		get_angle_relative_to_Gunner(get_tree().get_nodes_in_group("Gunner")[0].global_position)
		- PI / 2
	)
	info_label.text = str(self.rotation_degrees)
	match self.state:
#		HealthBody2D.DEAD
		2:
			if not (explosion.get_node("ExplosionParticles").emitting):
				explosion.position = self.position
#				print(self.global_position)
				var boom = get_tree().get_nodes_in_group("World3D")[0].get_node("Boom")

				if get_tree().get_first_node_in_group("Settings").get("sound_on"):
					boom.play()
				explosion.get_node("ExplosionParticles").emitting = true


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
#	print(self.rotation_degrees)
#	self.rotation_degrees = rad_to_deg( get_angle_relative_to_Gunner(get_tree().get_nodes_in_group("Gunner")[0].position))
#	self.rotation_degrees = -45
#	print("Shoot Gunner:" + str(self.rotation_degrees))
	var bullet = bullet_scene.instantiate()
	add_child(bullet)
#	bullet.rotation_degrees = self.rotation_degrees
	bullet.position.y += get_node("Area2D/CollisionShape2D").shape.size.y
	var v = Vector2(0, 1000)
	bullet.shoot(v.rotated(self.rotation))


func _on_Boom_finished():
	pass


func configure(new_shooting_rate):
	shooting_rate = new_shooting_rate


func get_angle_relative_to_Gunner(gunner_pos: Vector2):
#	var current_angle = self.global_position.direction_to(gunner_pos).angle()
	var current_angle = self.global_position.angle_to_point(gunner_pos)
	return current_angle


func _on_VisibilityNotifier2D_viewport_exited(viewport):
	pass
#	queue_free()
#	shoot_bullet_timer.queue_free()
