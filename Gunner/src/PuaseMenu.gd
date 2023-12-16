extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$ResumeButton.process_mode = Node.PROCESS_MODE_ALWAYS
	$ResumeButton.connect("pressed", Callable(self, "unpause"))


#	self.sposition = get_node("Gunner1").position
#	self.always_on_top = true
#	self.transient = true
#	self.exclusive = true


#
func _unhandled_input(input: InputEvent):
#	print()
	if input.is_action_pressed("ui_pause"):
		print("Pausing...")
		get_tree().paused = false if get_tree().paused else true


#		self.position.y = get_parent().get_node("Gunner1").position.y
#		var driver_pos = get_parent().get_node("EasyStageScene/ParallaxDriver").position.y
#		var middle_pos = (
#			(
#				get_parent()
#				. get_node("EasyStageScene/EasyStage/ParallaxLayer/Background")
#				. get_viewport_rect()
#				. size
#				. y
#			)
#			/ 2
#		)
#
#		self.position.y = driver_pos - middle_pos
#		self.position = get_parent().get_node("Gunner").position
#		self.show()
#		get_tree().paused = true


func unpause():
	get_tree().paused = false
	self.hide()
