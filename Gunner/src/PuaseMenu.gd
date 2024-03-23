extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$Menu/ResumeButton.process_mode = Node.PROCESS_MODE_ALWAYS
	$Menu/ResumeButton.connect("pressed", Callable(self, "toggle_pause"))


func _unhandled_input(input: InputEvent):
	if input.is_action_pressed("ui_pause"):
		toggle_pause()


func toggle_pause():
	self.position = get_parent().get_node("Player").get_node("Gunner1").position
	var screen_size = get_viewport_rect()
	self.position.x = screen_size.size.x / 2 - (self.get_size().x / 2)
	#self.position.y = screen_size.size.y / 2 - (self.get_size().y / 2)
	self.position.y = (
		get_parent().get_node("EasyStageScene").get_node("ParallaxDriver").position.y
		- (screen_size.size.y / 2)
	)
	get_tree().paused = false if get_tree().paused else true
	if get_tree().paused:
		self.show()
	else:
		self.hide()
