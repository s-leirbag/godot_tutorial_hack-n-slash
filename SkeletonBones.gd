extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 20

var motion = Vector2()

func _process(delta):
	motion.y += GRAVITY
	if is_on_floor():
		motion.x = 0
		motion.y = 0
	
	motion = move_and_slide(motion, UP)