extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
#	linear_velocity.x = 100
#	linear_velocity.y = 100
#	linear_velocity.x =  100
	pass

func destroy():
	queue_free()
	var boom = get_tree().get_nodes_in_group("World")[0].get_node("Boom")
	boom.play()
#	$Boom.
#	while($Boom.playing):
#		pass
#	queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Boom_finished():
	pass
