# Player.gd
extends "res://Character.gd"

# Movement constants
const ACCEL = 50
const MAX_SPEED = 200
const ROLL_SPEED = 275
const JUMP_HEIGHT = -300

# Weapon constants
const Attack1 = {DAMAGE = 5, KNOCKBACK = Vector2(150, 0), TYPE = "polygon", X = 0, Y = 0, POINTS = PoolVector2Array([Vector2(-17, -8), Vector2(21, 1), Vector2(31, 5), Vector2(37, 10), Vector2(37, 15), Vector2(26, 17), Vector2(8, 14), Vector2(-7, 6)])}
const Attack2 = {DAMAGE = 5, KNOCKBACK = Vector2(150, 0), TYPE = "polygon", X = 0, Y = 0, POINTS = PoolVector2Array([Vector2(-13, -6), Vector2(-3, -11), Vector2(16, -11), Vector2(35, -3), Vector2(42, 5), Vector2(47, 18), Vector2(27, 18), Vector2(32, 14), Vector2(28, 4), Vector2(19, -3)])}
const Attack3 = {DAMAGE = 8, KNOCKBACK = Vector2(400, 0), TYPE = "rectangle", X = 34.5, Y = 10, WIDTH = 27.5, HEIGHT = 2}

var has_jump = true
var has_roll = true
var kills = 0
var level = 1

func _ready():
	max_hp = 25
	hp = 25
	state = "move"

func _process(delta):
	var friction = true
	motion.y += GRAVITY
	
	match state:
		"move":
			if Input.is_action_just_pressed("lclick"):
				state = "attack1"
				$AnimatedSprite.play("attack1")
				$AnimatedSprite.offset.x = 5 * dir
				$Hitbox.setup(Attack1, dir)
			elif Input.is_action_just_pressed("shift"):
				if is_on_floor():
					motion.x = ROLL_SPEED * dir
					state = "roll"
					$AnimatedSprite.play("roll")
					$AnimatedSprite.offset.x = -7 * dir
					friction = false
					invulnerable = true
					has_roll = true
				elif has_roll:
					motion.x = ROLL_SPEED * dir
					state = "roll"
					$AnimatedSprite.play("roll")
					$AnimatedSprite.offset.x = -7 * dir
					friction = false
					invulnerable = true
					has_roll = false
			elif Input.is_action_just_pressed("w"):
				if is_on_floor():
					motion.y = JUMP_HEIGHT
					has_jump = true
					has_roll = true
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
			if Input.is_action_just_pressed("w"):
				if is_on_floor():
					motion.y = JUMP_HEIGHT
					has_jump = true
					state = "move"
				elif has_jump:
					motion.y = JUMP_HEIGHT
					has_jump = false
					state = "move"
		"attack1":
			if frame_in_range(0, 1):
				$Hitbox.set_physics_process(true)
			else:
				$Hitbox.set_physics_process(false)
				if frame_in_range(2, 4) and Input.is_action_just_pressed("lclick"):
					state = "attack2"
					$AnimatedSprite.play("attack2")
					$AnimatedSprite.offset.x = 19 * dir
					$Hitbox.setup(Attack2, dir)
		"attack2":
			if frame_in_range(1, 2):
				$Hitbox.set_physics_process(true)
			else:
				$Hitbox.set_physics_process(false)
				if frame_in_range(3, 4) and Input.is_action_just_pressed("lclick"):
					state = "attack3"
					$AnimatedSprite.play("attack3")
					$AnimatedSprite.offset.x = 19 * dir
					$Hitbox.setup(Attack3, dir)
		"attack3":
			if frame_in_range(2, 3):
				$Hitbox.set_physics_process(true)
			else:
				$Hitbox.set_physics_process(false)
		"knockback":
			if motion.x < 1:
				state = "move"

	if friction == true:
		if is_on_floor():
			motion.x = lerp(motion.x, 0, 0.2)
		else:
			motion.x = lerp(motion.x, 0, 0.05)
	
	motion = move_and_slide(motion, UP)

func _on_AnimatedSprite_animation_finished():
	if state == "roll" or state == "attack1" or state == "attack2" or state == "attack3":
		state = "move"
		if invulnerable:
			invulnerable = false