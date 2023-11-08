extends Popup


# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	$ResumeButton.process_mode = Node.PROCESS_MODE_ALWAYS
	$ResumeButton.connect("pressed", Callable(self, "unpause"))


func _unhandled_input(input: InputEvent):
	if input.is_action("ui_pause"):
#		self.position.y = get_parent().get_node("Gunner1").position.y
		var driver_pos = get_parent().get_node("EasyStageScene/ParallaxDriver").position.y
		var middle_pos = (
			(
				get_parent()
				. get_node("EasyStageScene/EasyStage/ParallaxLayer/Background")
				. get_viewport_rect()
				. size
				. y
			)
			/ 2
		)

		self.position.y = driver_pos - middle_pos
		self.show()
		get_tree().paused = true


func unpause():
	get_tree().paused = false
	self.hide()
