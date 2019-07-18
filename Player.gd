extends KinematicBody2D

# Movement
const UP = Vector2(0, -1)
#const GRAVITY = 20
const ACCEL = 50
const MAX_SPEED = 200
const ROLL_SPEED = 275
#const JUMP_HEIGHT = -300

# Weapon
const WEAPON_DAMAGE = 1
const WEAPON_KNOCKBACK = 1
const Attack1 = {X = 10.5, Y = 4.5, WIDTH = 26.5, HEIGHT = 12.5}
const Attack2 = {X = 16.5, Y = 3.5, WIDTH = 29.5, HEIGHT = 14.5}
const Attack3 = {X = 34.5, Y = 10, WIDTH = 27.5, HEIGHT = 2}

var motion = Vector2()
var state = "move"
var dir = 1
#var has_jump = true

func _ready():
	#Hitbox setup
	#instace hitbox (to-do)
	
	$Hitbox.set_physics_process(false)

func _process(delta):
#	motion.y += GRAVITY
	var friction = true
	
	match state:
		"move":
			if Input.is_action_just_pressed("lclick"):
				state = "attack1"
				$AnimatedSprite.play("attack1")
				$AnimatedSprite.offset.x = 5 * dir
				$Hitbox.setup(Attack1, dir, get_path(), WEAPON_DAMAGE, WEAPON_KNOCKBACK)
			elif Input.is_action_just_pressed("shift"):
				motion.x = ROLL_SPEED * dir
				state = "roll"
				$AnimatedSprite.play("roll")
				$AnimatedSprite.offset.x = -7 * dir
				friction = false
#			elif Input.is_action_just_pressed("w"):
#				if is_on_floor():
#					motion.y = JUMP_HEIGHT
#					has_jump = true
#				elif has_jump:
#					motion.y = JUMP_HEIGHT
#					has_jump = false
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
			if frame_in_range(0, 1):
				$Hitbox.set_physics_process(true)
			else:
				$Hitbox.set_physics_process(false)
				if frame_in_range(2, 4) and Input.is_action_just_pressed("lclick"):
					state = "attack2"
					$AnimatedSprite.play("attack2")
					$AnimatedSprite.offset.x = 19 * dir
					$Hitbox.setup(Attack2, dir, get_path(), WEAPON_DAMAGE, WEAPON_KNOCKBACK)
		"attack2":
			if frame_in_range(1, 2):
				$Hitbox.set_physics_process(true)
			else:
				$Hitbox.set_physics_process(false)
				if frame_in_range(3, 4) and Input.is_action_just_pressed("lclick"):
					state = "attack3"
					$AnimatedSprite.play("attack3")
					$AnimatedSprite.offset.x = 19 * dir
					$Hitbox.setup(Attack3, dir, get_path(), WEAPON_DAMAGE, WEAPON_KNOCKBACK)
		"attack3":
			if frame_in_range(2, 3):
				$Hitbox.set_physics_process(true)
			else:
				$Hitbox.set_physics_process(false)

	if friction == true:
		motion.x = lerp(motion.x, 0, 0.2)
#		for jumps
#		if is_on_floor():
#			motion.x = lerp(motion.x, 0, 0.2)
#		else:
#			motion.x = lerp(motion.x, 0, 0.05)
		
	motion = move_and_slide(motion, UP)

func _on_AnimatedSprite_animation_finished():
	if state == "roll" or state == "attack1" or state == "attack2" or state == "attack3":
		state = "move"
		
func frame_in_range(low, high):
	return $AnimatedSprite.frame >= low and $AnimatedSprite.frame <= high