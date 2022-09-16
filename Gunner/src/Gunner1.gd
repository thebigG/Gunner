extends HealthBody2D

export(PackedScene) var bullet_scene

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


# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = true
	add_child(hurt_animation)
	hurt_animation.interpolate_property(
		self, "visible", false, true, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	self.damage_interval = 0.10
	health_bar.max_value = self.MAX_HEALTH
	health_bar.min_value = self.ZERO_HEALTH

	health_bar.alignment = HALIGN_RIGHT

	health_bar.step = self.damage_interval

	screen_size = get_viewport_rect()

	print(health_bar.anchor_right)
	print(health_bar.anchor_bottom)
#	health_bar.rect_size = Vector2(25, 25)

	health_bar.set_size(Vector2(25, 25))

	speed = get_parent().get_node("EasyStageScene/ParallaxDriver").get("speed")
	current_velocity.y = -speed

	hud = hud_scene.instance()
	hud.rect_size.x = screen_size.size.x - 300
	hud_grid = hud.get_child(0)

	health_bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	hud.rect_position = Vector2(
		screen_size.size.x - 600,
		clamp(
			position.y,
			get_parent().get_node("EasyStageScene/ParallaxDriver").position.y - 600,
			get_parent().get_node("EasyStageScene/ParallaxDriver").position.y
		)
	)

	health_bar.theme = load("res://Assets/Themes/health_bar_theme.tres")
	health_bar.value = self.health

	hud.theme = hud_theme
	score_label.text = "Score:\n" + str(score)
	hud_grid.add_child(health_bar)
	hud_grid.add_child(score_label)

	get_parent().get_node("EasyStageScene").add_child(hud)


func _physics_process(delta):
	hud.rect_position = Vector2(
		screen_size.size.x - 600,
		clamp(
			hud.rect_position.y,
			get_parent().get_node("EasyStageScene/ParallaxDriver").position.y - 600,
			get_parent().get_node("EasyStageScene/ParallaxDriver").position.y
		)
	)

	health_bar.value = self.health
#	match self.state:
#		HealthBody2D.DEAD:
#			print("Gunner is dead")

	if Input.is_action_just_pressed("ui_shoot"):
		var new_bullet = bullet_scene.instance()
#		connect(signal: String, target: Object, method: String, binds: Array = [  ], flags: int = 0)

		new_bullet.connect("hit_signal", self, "increment_score")
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
		current_velocity.y = speed / 2
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
	position.x = clamp(position.x, 0, screen_size.size.x - 100)

	position.y = clamp(
		position.y,
		get_parent().get_node("EasyStageScene/ParallaxDriver").position.y - 600,
		get_parent().get_node("EasyStageScene/ParallaxDriver").position.y
	)


func increment_score():
	score += 1
	score_label.text = "Score:\n" + str(score)

func damage():
	Input.start_joy_vibration(0, 0.5, 0, 1)
	if hurt_animation.is_active():
		hurt_animation.stop_all()
	hurt_animation.interpolate_property(
		self, "visible", false, true, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	hurt_animation.start()
	.damage()
