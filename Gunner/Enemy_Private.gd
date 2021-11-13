extends BaseEnemy2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

#TODO:Abstract out the damage(destroy) and shoot functions in an interface.
#This way the Bullet code(or any other Node) can call these 
#functions without having to guess the type of Enemy.
func destroy():
	print(self.health)
	match self.state:
		BaseEnemy2D.ALIVE:
			print("Alive")
			
	queue_free()
	var boom = get_tree().get_nodes_in_group("World")[0].get_node("Boom")
	boom.play()

func _exit_tree():
	pass

func _on_Boom_finished():
	pass

func _on_VisibilityNotifier2D_viewport_exited(viewport):
	queue_free()
