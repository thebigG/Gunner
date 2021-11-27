extends KinematicBody2D


var current_direction = Vector2()
var screen_size
var speed = 5
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect()
	current_direction.y = -speed
	
func _physics_process(delta):
#	current_direction
#	position.x = clamp(position.x, 0, screen_size.size.x-24)
	move_and_collide(current_direction)
