extends Node2D

var level: PackedScene = preload("res://scene/Level1.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(level.instantiate())


func _physics_process(delta):
	pass
