# Player.gd
extends "res://Character.gd"

signal game_over

var SkeletonBones = load("res://SkeletonBones.tscn")

# Movement constants
const ACCEL = 50
const MAX_SPEED = 200
const ROLL_SPEED = 275
const JUMP_HEIGHT = -300

# Weapon constants
const Attack1 = {DAMAGE = 5, KNOCKBACK = Vector2(150, 0), TYPE = "polygon", POINTS = PoolVector2Array([Vector2(-17, -8), Vector2(21, 1), Vector2(31, 5), Vector2(37, 10), Vector2(37, 15), Vector2(26, 17), Vector2(8, 14), Vector2(-7, 6)])}
const Attack2 = {DAMAGE = 5, KNOCKBACK = Vector2(150, 0), TYPE = "polygon", POINTS = PoolVector2Array([Vector2(-13, -6), Vector2(-3, -11), Vector2(16, -11), Vector2(35, -3), Vector2(42, 5), Vector2(47, 18), Vector2(27, 18), Vector2(32, 14), Vector2(28, 4), Vector2(19, -3)])}
const Attack3 = {DAMAGE = 8, KNOCKBACK = Vector2(400, 0), TYPE = "rectangle", X = 34.5, Y = 10, WIDTH = 27.5, HEIGHT = 2}

var has_jump = true
var has_roll = true
var kills = 0
var level = 1
var experience = 0
var max_experience = 10
var strength = 25

func _ready():
	experience_yield = max_experience + experience
	hp = 25
	max_hp = hp
	state = "move"

func _process(delta):
	experience_yield = max_experience + experience
	
	var friction = true
	motion.y += GRAVITY * delta
	
	match state:
		"move":
			if Input.is_action_just_pressed("lclick"):
				state = "attack1"
				swipe_sound_played = false
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
					has_roll = true
					invulnerable = true
				elif has_roll:
					motion.x = ROLL_SPEED * dir
					state = "roll"
					$AnimatedSprite.play("roll")
					$AnimatedSprite.offset.x = -7 * dir
					friction = false
					has_roll = false
					invulnerable = true
			elif Input.is_action_just_pressed("w"):
				if is_on_floor():
					motion.y = JUMP_HEIGHT
					has_jump = true
					has_roll = true
				elif has_jump:
					motion.y = JUMP_HEIGHT
					has_jump = false
			elif not Input.is_action_pressed("d") and not Input.is_action_pressed("a"):
				$AnimatedSprite.play("idle")
				$AnimatedSprite.offset.x = -7 * dir
			else:
				if frame_in_range(2, 2) or frame_in_range(5, 5):
					get_node("/root/World/Footstep").play()
				if Input.is_action_pressed("d"):
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
		"roll":
			friction = false
			if Input.is_action_just_pressed("lclick"):
				state = "attack1"
				swipe_sound_played = false
				$AnimatedSprite.play("attack1")
				$AnimatedSprite.offset.x = 5 * dir
				$Hitbox.setup(Attack1, dir)
				invulnerable = false
			elif Input.is_action_just_pressed("w"):
				if is_on_floor():
					motion.y = JUMP_HEIGHT
					has_jump = true
					state = "move"
					invulnerable = false
				elif has_jump:
					motion.y = JUMP_HEIGHT
					has_jump = false
					state = "move"
					invulnerable = false
		"attack1":
			if frame_in_range(0, 1):
				$Hitbox.set_physics_process(true)
				if not swipe_sound_played:
					get_node("/root/World/Swipe").play()
					swipe_sound_played = true
			else:
				$Hitbox.set_physics_process(false)
				if frame_in_range(2, 4) and Input.is_action_just_pressed("lclick"):
					state = "attack2"
					swipe_sound_played = false
					$AnimatedSprite.play("attack2")
					$AnimatedSprite.offset.x = 19 * dir
					$Hitbox.setup(Attack2, dir)
		"attack2":
			if frame_in_range(1, 2):
				$Hitbox.set_physics_process(true)
				if not swipe_sound_played:
					get_node("/root/World/Swipe").play()
					swipe_sound_played = true
			else:
				$Hitbox.set_physics_process(false)
				if frame_in_range(3, 4) and Input.is_action_just_pressed("lclick"):
					state = "attack3"
					swipe_sound_played = false
					$AnimatedSprite.play("attack3")
					$AnimatedSprite.offset.x = 19 * dir
					$Hitbox.setup(Attack3, dir)
		"attack3":
			if frame_in_range(2, 3):
				$Hitbox.set_physics_process(true)
				if not swipe_sound_played:
					get_node("/root/World/Swipe").play()
					swipe_sound_played = true
			else:
				$Hitbox.set_physics_process(false)
		"knockback":
			if motion.x < 1:
				state = "move"
		"death":
			var rng = RandomNumberGenerator.new()
			rng.randomize()
			for frame in range(10): # 10 is number of skeleton bones
				var bone = SkeletonBones.instance()
				bone.get_node("AnimatedSprite").frame = frame
				bone.set_position(position + Vector2(rng.randi_range(-8, 8), rng.randi_range(-24, 8)))
				var direction = deg2rad(-90 + dir * rng.randi_range(0, 60))
				var speed = rng.randi_range(200, 350)
				bone.motion = speed * Vector2(cos(direction), sin(direction))
				
				if frame == 5:
					bone.set_rotation_degrees(160)
				else:
					bone.set_rotation_degrees(rng.randi_range(1, 360))
				
				get_node("/root/World").add_child(bone)
			
#			save score and update highscore in file
			var save_file = File.new()
			save_file.open("user://save_game.save", File.READ_WRITE)
			var content = parse_json(save_file.get_line())
			content.score = kills
			if not content.has("highscore") or kills > content.highscore:
				content.highscore = kills
			save_file.seek(0) # this line necessary????
			save_file.store_line(to_json(content))
			save_file.close()
			
			emit_signal("game_over")
			
			queue_free()

	if friction == true:
		if is_on_floor():
			motion.x = lerp(motion.x, 0, 0.175)
		else:
			motion.x = lerp(motion.x, 0, 0.05)
	
	motion = move_and_slide(motion, UP)

func _on_AnimatedSprite_animation_finished():
	if state == "roll" or state == "attack1" or state == "attack2" or state == "attack3":
		state = "move"
		if invulnerable:
			invulnerable = false