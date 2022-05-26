extends PopupDialog


# Called when the node enters the scene tree for the first time.
func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	$ResumeButton.pause_mode = Node.PAUSE_MODE_PROCESS
	$ResumeButton.connect("pressed", self, "unpause")


func _unhandled_input(input: InputEvent):
	if input.is_action("ui_pause"):
#		self.rect_position.y = get_parent().get_node("Gunner1").position.y
		var driver_pos = get_parent().get_node("EasyStageScene/ParallaxDriver").position.y
		var middle_pos = (
			get_parent().get_node("EasyStageScene/EasyStage/ParallaxLayer/Background").get_viewport_rect().size.y
			/ 2
		)

		self.rect_position.y = driver_pos - middle_pos
		self.show()
		get_tree().paused = true


func unpause():
	get_tree().paused = false
	self.hide()
