extends CharacterBody2D

var move_velocity = Vector2(0, 100)


# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D/Area2D.connect("body_entered", heal_gunner)
	$ObtainedSoundEffect.connect("finished", destroy)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.move_and_collide(move_velocity * delta)


func destroy():
	queue_free()


func heal_gunner(body):
	if body.is_in_group("Gunner"):
		$ObtainedSoundEffect.play()
		body.heal()
		self.visible = false
