extends HealthBody2D

@export var bullet_scene: PackedScene

var shoot_bullet_timer: Timer = Timer.new()
var shooting_rate = 1  # Hertz

var explosion_particles: PackedScene = preload("res://scene/Explosion.tscn")
var explosion: Node2D

var lifetime


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
	lifetime = particles.lifetime


func print_func(arg: Node):
	print("Arg:" + str(arg))


func after_explosion():
	queue_free()


func _physics_process(delta):
	self.rotation = (
		get_angle_relative_to_Gunner(get_tree().get_nodes_in_group("Gunner")[0].global_position)
		- PI / 2
	)
	if explosion.get_node("ExplosionParticles").emitting:
		lifetime -= delta
	match self.state:
#		HealthBody2D.DEAD
		2:
			if not (explosion.get_node("ExplosionParticles").emitting):
				var boom = get_tree().get_nodes_in_group("World3D")[0].get_node("Boom")

				if get_tree().get_first_node_in_group("Settings").get("sound_on"):
					boom.play()
				explosion.get_node("ExplosionParticles").emitting = true

			if lifetime < 0:
				pass
				#queue_free()


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
	get_tree().get_nodes_in_group("World3D")[0].add_child(bullet)
	bullet.position = self.global_position
	bullet.position.y += get_node("Area2D/CollisionShape2D").shape.size.y
	bullet.shoot(Vector2(0, 500).rotated(self.rotation))


func _on_Boom_finished():
	pass


func configure(new_shooting_rate):
	shooting_rate = new_shooting_rate


func _on_VisibilityNotifier2D_viewport_exited(viewport):
	pass


func get_angle_relative_to_Gunner(gunner_pos: Vector2):
	var current_angle = self.global_position.angle_to_point(gunner_pos)
	return current_angle
