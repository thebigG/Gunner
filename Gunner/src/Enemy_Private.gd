extends HealthBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D.connect("body_entered", self, "damage_gunner")

func _physics_process(delta):
	match self.state:			
		HealthBody2D.DEAD:
			queue_free()
			var boom = get_tree().get_nodes_in_group("World")[0].get_node("Boom")
			boom.play()

func damage_gunner(gunner: HealthBody2D):
	if(is_instance_valid(gunner) and gunner.is_in_group("Gunner")):
		Input.start_joy_vibration(0, 0.5, 0, 1)
		if(gunner.get("hurt_animation").is_active()):
			gunner.get("hurt_animation").stop_all() 
		gunner.get("hurt_animation").interpolate_property(gunner, "visible", false, true, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		gunner.get("hurt_animation").start()
		gunner.damage() 		

func _exit_tree():
	pass

func _on_Boom_finished():
	pass

func _on_VisibilityNotifier2D_viewport_exited(viewport):
	queue_free()
