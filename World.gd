extends Node2D

export(PackedScene) var enemy_scene
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func _physics_process(delta):
	var new_enemy = enemy_scene.instance()
	$Gunner1.position.y 
	print('position:' + str(new_enemy.transform.origin))
	new_enemy.transform.origin.y = $Gunner1.position.y - 700
	print('position for enemy:' + str(new_enemy.transform.origin))
	print('position for gunner:' + str($Gunner1.position))
	add_child(new_enemy)
#		new_bullet.shoot()
#		$Shoot.play()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
