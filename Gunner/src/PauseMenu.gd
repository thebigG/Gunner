extends Control

var last_sound_setting = null


# Called when the node enters the scene tree for the first time.
func _ready():
	$Menu/ResumeButton.process_mode = Node.PROCESS_MODE_ALWAYS
	$Menu/ResumeButton.connect("pressed", Callable(self, "toggle_pause"))
	$Menu/ToggleSound.connect("pressed", Callable(self, "toggle_sound"))
	$Menu/ToggleDevMode.connect("pressed", Callable(self, "toggle_dev_mode"))
	$Menu/RestartLevel.connect("pressed", Callable(self, "restart_level"))
	$Menu/Quit.connect("pressed", Callable(self, "quit_game"))
	var current_level = get_tree().get_first_node_in_group("World3D")
	print("current_level:" + str(current_level))


func _unhandled_input(input: InputEvent):
	if input.is_action_pressed("ui_pause"):
		toggle_pause()


func restart_level():
	#TODO: Will be a good place to save state(levels, scores, etc)...
	self.visible = false
	get_tree().reload_current_scene()


func quit_game():
	#TODO: Will be a good place to save state(levels, scores, etc)...
	get_tree().quit()


func toggle_pause():
	self.position = get_tree().get_first_node_in_group("Gunner").position
	var screen_size = get_viewport_rect()
	self.position.x = screen_size.size.x / 2 - (self.get_size().x / 2)
	self.position.y = (
		(
			get_tree()
			. get_first_node_in_group("World3D")
			. get_node("EasyStageScene")
			. get_node("ParallaxDriver")
			. position
			. y
		)
		- (screen_size.size.y / 2)
	)
	get_tree().paused = false if get_tree().paused else true
	if get_tree().paused:
		self.grab_focus()
		self.show()
	else:
		self.hide()


func toggle_sound():
	var settings_node = get_tree().get_first_node_in_group("Settings")
	var sound_setting = settings_node.get("sound_on")
	settings_node.set("sound_on", not (sound_setting))
	last_sound_setting = settings_node.get("sound_on")
	print("toggle sound...:" + str(settings_node.get("sound_on")))


func toggle_dev_mode():
	var settings_node = get_tree().get_first_node_in_group("Settings")
	var sound_setting = settings_node.get("dev_mode_on")
	settings_node.set("dev_mode_on", not (sound_setting))
	last_sound_setting = settings_node.get("dev_mode_on")
	print("dev mode ...:" + str(settings_node.get("dev_mode_on")))
