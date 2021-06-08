extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var current_direction = Vector2()
export var speed = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if Input.is_action_pressed("ui_right"):
			current_direction.x = speed
			current_direction.y = 0

	if Input.is_action_pressed("ui_left"):
			current_direction.x = -speed
			current_direction.y = 0
	if Input.is_action_pressed("ui_down"):
			current_direction.y = speed
			current_direction.x = 0

	if Input.is_action_pressed("ui_up"):
			current_direction.y = -speed
			current_direction.x = 0


	move_and_collide(current_direction)



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
