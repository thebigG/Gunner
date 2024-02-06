extends HealthBody2D

@export var bullet_scene: PackedScene

@export var desired_shooting_rate = 10.00
var current_velocity = Vector2()
var screen_size
var speed = 0
var health_bar = AlignedProgressBar.new()
var hurt_animation = Tween.new()
var hud_scene: PackedScene = preload("res://scene/HUD.tscn")
var hud: PanelContainer = null
var hud_grid: GridContainer = null
var hud_theme = preload("res://Assets/Themes/hud_theme.tres")
var score_label: Label = Label.new()
var score = 0
var hurt_sprite_frames = SpriteFrames.new()
var hurt_jet_sprites = AnimatedSprite2D.new()
var damaged_jet_texture = load("res://Assets/DamagedJet.png")
var time = 0
var horizontal_speed = 0

var dash_timer = Timer.new()
var dash_time = 3.0 # Seconds to dash for
var dashing  = false

var current_dash_time = 0 # Current/stateful time since the beginning of a dash 



# Called when the node enters the scene tree for the first time.
func _ready():
	hurt_sprite_frames.add_animation("Left")
	hurt_sprite_frames.add_animation("Right")
	hurt_sprite_frames.add_frame("Left", damaged_jet_texture, 0)
	hurt_sprite_frames.add_frame("Right", damaged_jet_texture, 0)
	self.visible = true
#	add_child(hurt_animation)

	self.damage_interval = 0.10
	health_bar.max_value = self.MAX_HEALTH
	health_bar.min_value = self.ZERO_HEALTH

	health_bar.alignment = 0

	health_bar.step = self.damage_interval

	screen_size = get_viewport_rect()

	health_bar.set_size(Vector2(10, 10))

	speed = get_parent().get_node("EasyStageScene/ParallaxDriver").get("speed")
	current_velocity.y = -speed

	hud = hud_scene.instantiate()
	hud.size.x = screen_size.size.x - 300
	hud.size.x = 300
	hud_grid = hud.get_child(0)
	hud_grid.columns = 2

	health_bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	hud.position = Vector2(
		screen_size.size.x / 2 - (hud.get_size().x / 2),
		clamp(
			position.y,
			get_parent().get_node("EasyStageScene/ParallaxDriver").position.y - 600,
			get_parent().get_node("EasyStageScene/ParallaxDriver").position.y
		)
	)

	health_bar.theme = load("res://Assets/Themes/health_bar_theme.tres")
	health_bar.value = self.health

	hud.theme = hud_theme
	score_label.text = "Score:" + str(score)
	hud_grid.add_child(score_label)
	hud_grid.add_child(health_bar)

	get_parent().get_node("EasyStageScene").add_child(hud)
	
#	dash_timer.timeout = dash_time


func _physics_process(delta):
	screen_size = get_viewport_rect()
	time += delta
	health_bar.value = self.health
	match self.state:
#		HealthBody2D.DEAD
		2:
			print("Gunner is dead")
#TODO: Need to avoid walking to the parent...
			get_parent().get_node("GameOver").restart_game()

	if Input.is_action_pressed("ui_shoot"):
		var calculated_rate_k = Engine.physics_ticks_per_second / desired_shooting_rate
		if time >= delta * calculated_rate_k:
			time = 0
			print("Shoot")
			var new_bullet = bullet_scene.instantiate()
			#		connect(signal: String,Callable(target: Object,method: String).bind(binds: Array = [  ),flags: int = 0)

			new_bullet.connect("hit_signal", Callable(self, "increment_score"))
			new_bullet.position.y -=10
			add_child(new_bullet) 
			$Shoot.play()
			new_bullet.shoot()

	$Turn.set_frame(0)

	if self.health <= 0.5:
		$Turn.set_sprite_frames(hurt_sprite_frames)

	current_velocity.x = 0
	current_velocity.y = speed * -1
	if Input.is_action_pressed("move_up"):
		current_velocity.y = (speed + 10) * (-1)
		print(current_velocity.y)

# TODO: Have to rethink this logic a bit since now Gunner has to keep up with the
# the velocity of the camera.

	if current_dash_time >= dash_time:
		dashing  = false
		current_dash_time = 0
	
	if dashing:
		current_dash_time += delta

#I think the best way to dash is to give Gunner acceleration for short period of time and wind down
	if Input.is_action_pressed("move_down"):
		current_velocity.y = speed / 2
	if not(dashing):
		if Input.is_action_just_pressed("dash_left"):
			horizontal_speed = speed * 4
			current_velocity.x = -horizontal_speed
			dashing = true
		elif Input.is_action_just_pressed("dash_right"):
			horizontal_speed = speed * 4
			current_velocity.x = horizontal_speed
			dashing = true
			
		else:
			horizontal_speed = speed
	if Input.is_action_pressed("move_right"):
		$Turn.set_animation("Right")
		$Turn.play()
		$Turn.set_frame(1)
		current_velocity.x = horizontal_speed

	#Would like a cleaner way of doing this...
	else:
		if $Turn.animation == "Right":
			$Turn.stop()
			$Turn.set_frame(0)

	if Input.is_action_pressed("move_left"):
		print("ui_left")
		$Turn.set_animation("Left")
		$Turn.play()
		$Turn.set_frame(1)
		current_velocity.x = -horizontal_speed
	else:
		if $Turn.animation == "Left":
			$Turn.stop()
			$Turn.set_frame(0)

	#	Figure out a way to limit the viewport for the player
	move_and_collide(current_velocity)

	position.x = clamp(position.x, 0, screen_size.size.x - 0)

	position.y = clamp(
		position.y,
		get_parent().get_node("EasyStageScene/ParallaxDriver").position.y - 600,
		get_parent().get_node("EasyStageScene/ParallaxDriver").position.y
	)

	position.y = clamp(
		position.y,
		get_parent().get_node("EasyStageScene/ParallaxDriver").position.y - screen_size.size.y,
		get_parent().get_node("EasyStageScene/ParallaxDriver").position.y
	)

	hud.position.y = get_parent().get_node("EasyStageScene/ParallaxDriver").position.y - 100


func increment_score():
	score += 1
	score_label.text = "Score:" + str(score)

#func damage():
#	Input.start_joy_vibration(0, 0.5, 0, 1)
#	if hurt_animation.is_active():
#		hurt_animation.stop_all()
#	hurt_animation.interpolate_property(
#		self, "visible", false, true, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
#	)
#	hurt_animation.start()
#	super.damage()
