extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D/Area2D.connect("body_entered", heal_gunner)
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func heal_gunner(body):
	if body.is_in_group("Gunner"):
		body.heal()
