# Boss.gd
extends "res://Character.gd"

# Constants
const WALK_SPEED = 15
const ATTACK_RANGE = 120
const BACKUP_RANGE = 96
const Attack = {DAMAGE = 10, KNOCKBACK = Vector2(1000, -90), TYPE = "polygon", POINTS = PoolVector2Array([Vector2(-51, -86), Vector2(34, -89), Vector2(96, -70), Vector2(130, -37), Vector2(148, 10), Vector2(148, 36), Vector2(96, 39), Vector2(83, -26), Vector2(61, -53), Vector2(0, -81)])}

var draw_hp

func _ready():
	experience_yield = 50
	hp = 100
	max_hp = hp
	draw_hp = hp
	state = "chase"
	$AnimatedSprite.play("walk")
	$AnimatedSprite.offset = Vector2(-2 * dir, -1)

func _process(delta):
	var friction = true
	
	match state:
		"idle":
			if has_node("/root/World/Player"):
				state = "chase"
				$AnimatedSprite.play("walk")
				$AnimatedSprite.offset = Vector2(-2 * dir, -1)
		"chase":
#			execute only if player exists
			if has_node("/root/World/Player"):
				var distance_to_player = position.distance_to(get_node("/root/World/Player").position)
				if distance_to_player <= ATTACK_RANGE and distance_to_player > BACKUP_RANGE:
					dir = (get_node("/root/World/Player").position.x - position.x) / abs(get_node("/root/World/Player").position.x - position.x)
					$AnimatedSprite.flip_h = false if dir > 0 else true
					
					state = "attack"
					$AnimatedSprite.play("attack")
					$AnimatedSprite.offset = Vector2(36 * dir, -43)
					$Hitbox.setup(Attack, dir)
				elif distance_to_player > ATTACK_RANGE:
					dir = (get_node("/root/World/Player").position.x - position.x) / abs(get_node("/root/World/Player").position.x - position.x)
					$AnimatedSprite.flip_h = false if dir > 0 else true
					
					motion.x = WALK_SPEED if $AnimatedSprite.flip_h == false else -WALK_SPEED
					$AnimatedSprite.offset = Vector2(-2 * dir, -1)
					friction = false
				elif distance_to_player < BACKUP_RANGE:
					dir = (get_node("/root/World/Player").position.x - position.x) / abs(get_node("/root/World/Player").position.x - position.x)
					$AnimatedSprite.flip_h = false if dir > 0 else true
					
					motion.x = -WALK_SPEED if $AnimatedSprite.flip_h == false else WALK_SPEED
					$AnimatedSprite.offset = Vector2(-2 * dir, -1)
					friction = false
			else:
				state = "idle"
				$AnimatedSprite.play("idle")
				$AnimatedSprite.offset = Vector2(2 * dir, 2)
		"attack":
			if frame_in_range(7, 8):
				$Hitbox.set_physics_process(true)
			else:
				$Hitbox.set_physics_process(false)
		"knockback":
			if motion.x < 1:
				state = "chase"
				$AnimatedSprite.play("walk")
				$AnimatedSprite.offset = Vector2(-2 * dir, -1)
		"death":
			$AnimatedSprite.modulate.a -= 1 / 1.2 * delta
	
	if friction == true:
		motion.x = lerp(motion.x, 0, 0.2)
#		for jumps
#		if is_on_floor():
#			motion.x = lerp(motion.x, 0, 0.2)
#		else:
#			motion.x = lerp(motion.x, 0, 0.05)
	
	motion = move_and_slide(motion, UP)
	
	var hp_percent
	draw_hp = lerp(draw_hp, hp, 0.2)
	hp_percent = float(draw_hp) / float(max_hp)
	$HealthBar.value = hp_percent * 100

func _on_HealthBarTimer_timeout():
	$HealthBar.visible = false

func _on_AnimatedSprite_animation_finished():
	if state == "attack":
		state = "stall"
		$StallTimer.start()
		$AnimatedSprite.stop()
	elif state == "death":
		queue_free()

func _on_StallTimer_timeout():
	state = "chase"
	$AnimatedSprite.play("walk")
	$AnimatedSprite.offset = Vector2(-2 * dir, -1)
