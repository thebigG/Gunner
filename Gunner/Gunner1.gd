extends KinematicBody2D

export(PackedScene) var bullet_scene

var current_direction = Vector2()
var screen_size
export var speed = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = $Body.get_viewport_rect()
	current_direction.y = -speed
	
func _physics_process(delta):
#	print('camera:' + str($Camera2D.get_camera_position()))
	if Input.is_action_just_pressed("ui_accept"):
		var new_bullet = bullet_scene.instance() 
		add_child(new_bullet)
		$Shoot.play()
		new_bullet.shoot()
		
	$Turn.set_frame(0)
	current_direction.x = 0
	if Input.is_action_pressed("ui_right"):
			$Turn.set_animation("Right")
			$Turn.play()
			$Turn.set_frame(1)
			print('current animation:' + $Turn.animation)
			current_direction.x = speed
	
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
	else:
		if $Turn.animation == "Left":
			$Turn.stop()
			$Turn.set_frame(0)
	
	if Input.is_action_pressed("ui_accept"):
		print("shoot")


#	Figure out a way to limit the viewport for the player
	move_and_collide(current_direction)
	
#	TODO: Figure out a cleaner way of clamping
	position.x = clamp(position.x, 100, screen_size.size.x-24)



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass