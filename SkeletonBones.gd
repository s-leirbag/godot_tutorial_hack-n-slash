extends KinematicBody2D

const GRAVITY = 0.2

var motion = Vector2()

func _ready():
	pass

func _process(delta):
	position += motion
	motion.y += GRAVITY