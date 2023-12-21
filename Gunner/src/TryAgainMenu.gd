extends Control

var game_over = false


# Called when the node enters the scene tree for the first time.
func _ready():
	$TryAGainButton.process_mode = Node.PROCESS_MODE_ALWAYS
	$TryAGainButton.connect("pressed", Callable(self, "try_again"))
	game_over = false


func _unhandled_input(input: InputEvent):
	if input.is_action_pressed("ui_shoot") and game_over:
		try_again()


func restart_game():
	self.position = get_parent().get_node("Gunner1").position
	var screen_size = get_viewport_rect()
	self.position.x = screen_size.size.x / 2 - (self.get_size().x / 2)
	self.show()
	get_tree().paused = true
	game_over = true


func try_again():
	get_tree().reload_current_scene()
