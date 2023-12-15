extends HealthBody2D

@export var bullet_scene: PackedScene

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


func _physics_process(delta):
	screen_size = get_viewport_rect()
	time += fmod(delta, 0.0166666666667)

	health_bar.value = self.health
	match self.state:
#		HealthBody2D.DEAD
		2:
			print("Gunner is dead")

	if Input.is_action_pressed("ui_shoot"):
		#Two bullets per second. Make this tunable.
		#The intervals of time should be expressed as functions of fps, etc
		if time >= 0.0166666666667 * 30:
			time = 0
			print("Shoot")
			var new_bullet = bullet_scene.instantiate()
			#		connect(signal: String,Callable(target: Object,method: String).bind(binds: Array = [  ),flags: int = 0)

			new_bullet.connect("hit_signal", Callable(self, "increment_score"))
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
	if Input.is_action_pressed("move_down"):
		current_velocity.y = speed / 2
#
	if Input.is_action_pressed("move_right"):
		$Turn.set_animation("Right")
		$Turn.play()
		$Turn.set_frame(1)
		current_velocity.x = speed

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
		current_velocity.x = -speed
	else:
		if $Turn.animation == "Left":
			$Turn.stop()
			$Turn.set_frame(0)

	#	Figure out a way to limit the viewport for the player
	move_and_collide(current_velocity)
#	print(
#		"size of frame:" + str($Turn.sprite_frames.get_frame_texture("Left", 0).get_size().x * 0.02)
#	)
#	position.x = clamp(position.x, 0, screen_size.size.x - ($Turn.sprite_frames.get_frame_texture("Left", 0).get_size().x * 0.1))

	position.x = clamp(position.x, 0, screen_size.size.x - 0)

#	print("screen_size.size.x:" + str(screen_size.size))
#
#	print("position.x:" + str(position.x))

	position.y = clamp(
		position.y,
		get_parent().get_node("EasyStageScene/ParallaxDriver").position.y - 600,
		get_parent().get_node("EasyStageScene/ParallaxDriver").position.y
	)

	hud.position.y = get_parent().get_node("EasyStageScene/ParallaxDriver").position.y - 100


#	print("delta:" + str(delta))


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
