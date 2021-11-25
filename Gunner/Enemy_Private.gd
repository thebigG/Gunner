extends BaseEnemy2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	match self.state:			
		BaseEnemy2D.DEAD:
			queue_free()
			var boom = get_tree().get_nodes_in_group("World")[0].get_node("Boom")
			boom.play()
			
func _exit_tree():
	pass

func _on_Boom_finished():
	pass

func _on_VisibilityNotifier2D_viewport_exited(viewport):
	queue_free()
