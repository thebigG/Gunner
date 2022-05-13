extends PopupDialog


# Called when the node enters the scene tree for the first time.
func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	$ResumeButton.pause_mode = Node.PAUSE_MODE_PROCESS
	$ResumeButton.connect("pressed", self, "unpause")


func _unhandled_input(input: InputEvent):
	if input.is_action("ui_pause"):
		self.rect_position.y = get_parent().get_node("Gunner1").position.y
		self.show()
		get_tree().paused = true


func unpause():
	get_tree().paused = false
	self.hide()
