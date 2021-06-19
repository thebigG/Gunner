extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var current_direction = Vector2()
var screen_size
export var speed = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = $Area2D.get_viewport_rect()
	
func _physics_process(delta):
	$Turn.set_frame(0)
	if Input.is_action_pressed("ui_right"):
			$Turn.set_animation("Right")
			$Turn.play()
			$Turn.set_frame(1)
			print('current animation:' + $Turn.animation)
			current_direction.x = speed
			current_direction.y = 0
	
	#Would like a cleaner way of doing this... 
	else:
		if $Turn.animation == "Right":
			$Turn.stop()
			$Turn.set_frame(0)

	if Input.is_action_pressed("ui_left"):
			$Turn.set_animation("Left")
			$Turn.play()
			$Turn.set_frame(1)
			current_direction.x = -speed
			current_direction.y = 0
	else:
		if $Turn.animation == "Left":
			$Turn.stop()
			$Turn.set_frame(0)
		
	if Input.is_action_pressed("ui_down"):
			current_direction.y = speed
			current_direction.x = 0

	if Input.is_action_pressed("ui_up"):
			current_direction.y = -speed
			current_direction.x = 0


#	Figure out a way to limit the viewport for the player
	move_and_collide(current_direction)
	
	position.x = clamp(position.x, 0, screen_size.size.x)
#	print("screen_size-->" + str(screen_size.position.x))
	
	print("posittion-->"+ str(position))
	print("clamped pos-->"+ str(clamp(position.x, 0, screen_size.size.x)))
#	position.x = clamp(position.x, 0, 1)



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
