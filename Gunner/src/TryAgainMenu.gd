extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$TryAGainButton.process_mode = Node.PROCESS_MODE_ALWAYS
	$TryAGainButton.connect("pressed", Callable(self, "try_again"))


func restart_game():
	self.position = get_parent().get_node("Gunner1").position
	var screen_size = get_viewport_rect()
	self.position.x = screen_size.size.x / 2 - (self.get_size().x / 2)
	self.show()
	get_tree().paused = true


func try_again():
	get_tree().reload_current_scene()
