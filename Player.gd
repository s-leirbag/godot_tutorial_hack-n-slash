extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 20
const ACCEL = 50
const MAX_SPEED = 200
const ROLL_SPEED = 275
const JUMP_HEIGHT = -300

var motion = Vector2()
var state = "move"
var dir = 1
var has_jump = true

func _physics_process(delta):
	motion.y += GRAVITY
	var friction = true
	
	match state:
		"move":
			if Input.is_action_just_pressed("lclick"):
				state = "attack1"
				$AnimatedSprite.play("attack1")
				$AnimatedSprite.offset.x = 5 * dir
				get_parent().get_node("Hitbox")
			elif Input.is_action_just_pressed("shift"):
				motion.x = ROLL_SPEED * dir
				state = "roll"
				$AnimatedSprite.play("roll")
				$AnimatedSprite.offset.x = -7 * dir
				friction = false
			elif Input.is_action_just_pressed("w"):
				if is_on_floor():
					motion.y = JUMP_HEIGHT
					has_jump = true
				elif has_jump:
					motion.y = JUMP_HEIGHT
					has_jump = false
			elif Input.is_action_pressed("d"):
				motion.x = min(motion.x + ACCEL, MAX_SPEED)
				dir = 1
				$AnimatedSprite.flip_h = false
				$AnimatedSprite.play("run")
				$AnimatedSprite.offset.x = -7
				friction = false
			elif Input.is_action_pressed("a"):
				motion.x = max(motion.x - ACCEL, -MAX_SPEED)
				dir = -1
				$AnimatedSprite.flip_h = true
				$AnimatedSprite.play("run")
				$AnimatedSprite.offset.x = 7
				friction = false
			else:
				$AnimatedSprite.play("idle")
				$AnimatedSprite.offset.x = -7 * dir
		"roll":
			friction = false
		"attack1":
			if $AnimatedSprite.frame >= 2 and $AnimatedSprite.frame <= 4 and Input.is_action_just_pressed("lclick"):
				state = "attack2"
				$AnimatedSprite.play("attack2")
				$AnimatedSprite.offset.x = 19 * dir
		"attack2":
			if $AnimatedSprite.frame >= 2 and $AnimatedSprite.frame <= 4 and Input.is_action_just_pressed("lclick"):
				state = "attack3"
				$AnimatedSprite.play("attack3")
				$AnimatedSprite.offset.x = 19 * dir

	if friction == true:
		if is_on_floor():
			motion.x = lerp(motion.x, 0, 0.2)
		else:
			motion.x = lerp(motion.x, 0, 0.05)
		
	motion = move_and_slide(motion, UP)

func _on_AnimatedSprite_animation_finished():
	if state == "roll" or state == "attack1" or state == "attack2" or state == "attack3":
		state = "move"