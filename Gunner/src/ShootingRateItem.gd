extends CharacterBody2D

var move_velocity = Vector2(0, 100)


# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D/Area2D.connect("body_entered", apply_boost_gunner)
	$ObtainedSoundEffect.connect("finished", destroy)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.move_and_collide(move_velocity * delta)


func destroy():
	queue_free()


func apply_boost_gunner(body):
	if body.is_in_group("Gunner"):
		var boost = 0.5
		var current_rate = body.get("desired_shooting_rate")
		current_rate = current_rate + (current_rate * boost)
		body.set("desired_shooting_rate", current_rate)
		$ObtainedSoundEffect.play()
		self.visible = false
