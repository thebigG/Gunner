extends HealthBody2D

@export var bullet_scene: PackedScene

@export var bullet_missile_scene: PackedScene

var desired_shooting_rate = 12.00
var desired_special_weapon_shooting_rate = 1.00
var current_velocity = Vector2()
var screen_size
var cruising_speed = 0
var thrust = 10  # Not sure if this is the best name...
var health_bar = AlignedProgressBar.new()
var hurt_animation = Tween.new()
var hud_scene: PackedScene = preload("res://scene/HUD.tscn")
var hud: PanelContainer = null
var hud_grid: GridContainer = null
var hud_theme = preload("res://Assets/Themes/hud_theme.tres")
var score_label: Label = Label.new()
var level_progress: Label = Label.new()
var score = 0
var hurt_sprite_frames = SpriteFrames.new()
var hurt_jet_sprites = AnimatedSprite2D.new()
var damaged_jet_texture = load("res://Assets/DamagedJet.png")
var bullet_time = 0
var special_bullet_time = 0
var jet_texture_sprites = null


# Called when the node enters the scene tree for the first time.
func _ready():
	jet_texture_sprites = $Turn.sprite_frames
	hurt_sprite_frames.add_animation("Left")
	hurt_sprite_frames.add_animation("Right")
	hurt_sprite_frames.add_frame("Left", damaged_jet_texture, 0)
	hurt_sprite_frames.add_frame("Right", damaged_jet_texture, 0)
	self.visible = true

	self.damage_interval = 0.10
	health_bar.max_value = self.MAX_HEALTH
	health_bar.min_value = self.ZERO_HEALTH

	health_bar.alignment = 0

	health_bar.step = self.damage_interval

	screen_size = get_viewport_rect()

	health_bar.set_size(Vector2(10, 10))

	cruising_speed = get_parent().get_parent().get_node("EasyStageScene/ParallaxDriver").get(
		"speed"
	)
#	current_velocity.y = -speed

	hud = hud_scene.instantiate()
	hud.size.x = screen_size.size.x - 300
	hud.size.x = 300
	hud_grid = hud.get_child(0)
	hud_grid.columns = 3

	health_bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	hud.position = Vector2(
		screen_size.size.x / 2 - (hud.get_size().x / 2),
		clamp(
			position.y,
			get_parent().get_parent().get_node("EasyStageScene/ParallaxDriver").position.y - 600,
			get_parent().get_parent().get_node("EasyStageScene/ParallaxDriver").position.y
		)
	)

	health_bar.theme = load("res://Assets/Themes/health_bar_theme.tres")
	health_bar.value = self.health

	hud.theme = hud_theme
	score_label.text = "Score:" + str(score)
	level_progress.text = (
		"Progress:"
		+ str(get_tree().get_first_node_in_group("World3D").call("get_current_level_progress"))
	)
	hud_grid.add_child(score_label)
	hud_grid.add_child(health_bar)
	hud_grid.add_child(level_progress)

	get_parent().get_parent().get_node("EasyStageScene").add_child(hud)


func _physics_process(delta):
	var current_progress = str(
		get_tree().get_first_node_in_group("World3D").call("get_current_level_progress")
	)
	print("current_progress:" + str(current_progress))
	level_progress.text = "Progress:" + current_progress
	if get_tree().get_first_node_in_group("Settings").get("dev_mode_on"):
		$LabelPos.visible = true

	else:
		$LabelPos.visible = false
	$LabelPos.set_text(str(self.position))
	screen_size = get_viewport_rect()
	bullet_time += delta
	special_bullet_time += delta
	health_bar.value = self.health
	match self.state:
#		HealthBody2D.DEAD
		2:
			print("Gunner is dead")
#TODO: Need to avoid walking to the parent...
			get_parent().get_parent().get_node("GameOver").restart_game()

	if Input.is_action_pressed("ui_shoot"):
		var calculated_rate_k = Engine.physics_ticks_per_second / desired_shooting_rate
		if bullet_time >= delta * calculated_rate_k:
			bullet_time = 0
			var new_bullet = bullet_scene.instantiate()
			#		connect(signal: String,Callable(target: Object,method: String).bind(binds: Array = [  ),flags: int = 0)

			new_bullet.connect("hit_signal", Callable(self, "increment_score"))
			new_bullet.global_position = self.global_position
			#Prevent bullet from colliding with Gunner and avoid "Push back" effect from bullet.
			new_bullet.global_position.y -= 50
			#add_child(new_bullet)
			self.get_parent().add_child(new_bullet)
			if get_tree().get_first_node_in_group("Settings").get("sound_on"):
				$Shoot.play()

			new_bullet.shoot(get_bullet_velocity())

	if Input.is_action_pressed("special_weapon"):
#TODO: I think what might make the most sense for "special" weapon is a timeout rather than a "rate", maybe...
#Though the same outcome can be achieved with a rate at the end of the day
		var calculated_rate_k = (
			Engine.physics_ticks_per_second / desired_special_weapon_shooting_rate
		)
		if special_bullet_time >= delta * calculated_rate_k:
			special_bullet_time = 0
			print("Shoot Missile")
			var special_missiles = []
			for i in range(10):
				var new_bullet = bullet_missile_scene.instantiate()
				#		connect(signal: String,Callable(target: Object,method: String).bind(binds: Array = [  ),flags: int = 0)

				new_bullet.connect("hit_signal", Callable(self, "increment_score"))
				#Prevent bullet from colliding with Gunner and avoid "Push back" effect from bullet.
				new_bullet.global_position = self.global_position
				new_bullet.global_position.y -= 25
				print("new_bullet.global_position:" + str(new_bullet.global_position))
				self.get_parent().add_child(new_bullet)
				if get_tree().get_first_node_in_group("Settings").get("sound_on"):
					$Shoot.play()

				var vel: Vector2 = get_special_bullet_velocity()
				#vel.set
				new_bullet.shoot(get_special_bullet_velocity())
				#special_missiles.append()
			#var new_bullet = bullet_missile_scene.instantiate()
			##		connect(signal: String,Callable(target: Object,method: String).bind(binds: Array = [  ),flags: int = 0)
#
	#new_bullet.connect("hit_signal", Callable(self, "increment_score"))
	##Prevent bullet from colliding with Gunner and avoid "Push back" effect from bullet.
	#new_bullet.global_position = self.global_position
	#new_bullet.global_position.y -= 25
	#print("new_bullet.global_position:" + str(new_bullet.global_position))
	#self.get_parent().add_child(new_bullet)
	#if get_tree().get_nodes_in_group("World3D")[0].get("sound_on"):
	#$Shoot.play()
#
	#new_bullet.shoot(get_special_bullet_velocity())

	$Turn.set_frame(0)

	if self.health <= 0.5:
		$Turn.set_sprite_frames(hurt_sprite_frames)

	elif self.health > 0.5:
		$Turn.set_sprite_frames(jet_texture_sprites)

	current_velocity.x = 0
	current_velocity.y = cruising_speed * -1
	if Input.is_action_pressed("move_up"):
		current_velocity.y = (cruising_speed + thrust) * (-1)
		print(current_velocity.y)

# TODO: Have to rethink this logic a bit since now Gunner has to keep up with the
# the velocity of the camera.
	if Input.is_action_pressed("move_down"):
		current_velocity.y = (cruising_speed + thrust)
#
	if Input.is_action_pressed("move_right"):
		$Turn.set_animation("Right")
		$Turn.play()
		$Turn.set_frame(1)
		current_velocity.x = cruising_speed + thrust

	#Would like a cleaner way of doing this...
	else:
		if $Turn.animation == "Right":
			$Turn.stop()
			$Turn.set_frame(0)

	if Input.is_action_pressed("move_left"):
		$Turn.set_animation("Left")
		$Turn.play()
		$Turn.set_frame(1)
		current_velocity.x = (-1) * (cruising_speed + thrust)
	else:
		if $Turn.animation == "Left":
			$Turn.stop()
			$Turn.set_frame(0)

	#	Figure out a way to limit the viewport for the player
	move_and_collide(current_velocity)

	position.x = clamp(position.x, 0, screen_size.size.x - 0)

	position.y = clamp(
		position.y,
		get_parent().get_parent().get_node("EasyStageScene/ParallaxDriver").position.y - 600,
		get_parent().get_parent().get_node("EasyStageScene/ParallaxDriver").position.y
	)

	position.y = clamp(
		position.y,
		(
			get_parent().get_parent().get_node("EasyStageScene/ParallaxDriver").position.y
			- screen_size.size.y
		),
		get_parent().get_parent().get_node("EasyStageScene/ParallaxDriver").position.y
	)

	hud.position.y = (
		get_parent().get_parent().get_node("EasyStageScene/ParallaxDriver").position.y - 100
	)


func get_bullet_velocity():
	return Vector2(0, desired_shooting_rate * -100)


func get_special_bullet_velocity():
	return Vector2(0, desired_special_weapon_shooting_rate * -500)


func increment_score():
	score += 1
	score_label.text = "Score:" + str(score)


#func heal():
#self.health = 1.0

#func damage():
#	Input.start_joy_vibration(0, 0.5, 0, 1)
#	if hurt_animation.is_active():
#		hurt_animation.stop_all()
#	hurt_animation.interpolate_property(
#		self, "visible", false, true, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
#	)
#	hurt_animation.start()
#	super.damage()


func damage_gunner():
	Input.start_joy_vibration(0, 0.5, 0, 0.5)
	if hurt_animation.is_running():
		hurt_animation.stop()
	var tween = get_tree().create_tween()
	tween.tween_property($Turn, "visible", false, 0.5).set_trans(Tween.TRANS_LINEAR).set_ease(
		Tween.EASE_IN_OUT
	)
	tween.tween_property($Turn, "visible", true, 0.5).set_trans(Tween.TRANS_LINEAR).set_ease(
		Tween.EASE_IN_OUT
	)
	tween.play()
	self.damage()
