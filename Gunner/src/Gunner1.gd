extends HealthBody2D

export(PackedScene) var bullet_scene

var current_velocity = Vector2()
var screen_size
var speed = 0
var health_bar = ProgressBar.new()
var hurt_animation = Tween.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = true
	add_child(hurt_animation)
	hurt_animation.interpolate_property(self, "visible", false, true, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	self.damage_interval = 0.10
	health_bar.max_value = self.MAX_HEALTH
	health_bar.min_value = self.ZERO_HEALTH
	
	
	
	
	health_bar.step = self.damage_interval
	
	health_bar.rect_position = Vector2(0,0)
	screen_size = get_viewport_rect()
	health_bar.rect_position = Vector2(screen_size.size.x-600, clamp(position.y, 
				 get_parent().get_node("EasyStageScene/ParallaxDriver").position.y - 600,
				 get_parent().get_node("EasyStageScene/ParallaxDriver").position.y ))
	health_bar.rect_size = Vector2(100,25)
	speed = get_parent().get_node("EasyStageScene/ParallaxDriver").get("speed")
	current_velocity.y = -speed

	health_bar.theme = load("res://Assets/Themes/health_bar_theme.tres")
	health_bar.value = self.health
	get_parent().get_node("EasyStageScene").add_child(health_bar)
	
func _physics_process(delta):
	health_bar.rect_position = Vector2(screen_size.size.x-600, clamp(health_bar.rect_position.y, 
			 get_parent().get_node("EasyStageScene/ParallaxDriver").position.y - 600,
			 get_parent().get_node("EasyStageScene/ParallaxDriver").position.y ))
	health_bar.value = self.health
#	match self.state:			
#		HealthBody2D.DEAD:
#			print("Gunner is dead")
	
	if Input.is_action_just_pressed("ui_shoot"):
		var new_bullet = bullet_scene.instance() 
		add_child(new_bullet)
		$Shoot.play()
		new_bullet.shoot()
	$Turn.set_frame(0)
	
	current_velocity.x = 0
	current_velocity.y = speed * -1
	if Input.is_action_pressed("ui_up"):
			current_velocity.y = (speed + 10) * (-1)
			print(current_velocity.y)

# TODO: Have to rethink this logic a bit since now Gunner has to keep up with the
# the velocity of the camera.
	if Input.is_action_pressed("ui_down"):
			current_velocity.y = speed/2
#
	if Input.is_action_pressed("ui_right"):
			$Turn.set_animation("Right")
			$Turn.play()
			$Turn.set_frame(1)
			current_velocity.x = speed

	#Would like a cleaner way of doing this... 
	else:
		if $Turn.animation == "Right":
			$Turn.stop()
			$Turn.set_frame(0)

	if Input.is_action_pressed("ui_left"):
			$Turn.set_animation("Left")
			$Turn.play()
			$Turn.set_frame(1)
			current_velocity.x = -speed
	else:
		if $Turn.animation == "Left":
			$Turn.stop()
			$Turn.set_frame(0)

	#	Figure out a way to limit the viewport for the player
	move_and_collide(current_velocity)
	position.x = clamp(position.x, 0, screen_size.size.x-100)
	
	position.y = clamp(position.y, 
				 get_parent().get_node("EasyStageScene/ParallaxDriver").position.y - 600,
				 get_parent().get_node("EasyStageScene/ParallaxDriver").position.y )
