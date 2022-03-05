extends KinematicBody2D


var current_direction = Vector2()
var screen_size
var speed = 5
var game_started = false
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect()
	current_direction.y = -speed
	
func _physics_process(delta):
	if game_started:
		move_and_collide(current_direction)

func start_game():
	game_started = true
