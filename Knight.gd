# Knight.gd
extends "res://Character.gd"

# Constants
const WALK_SPEED = 20
const ATTACK_RANGE = 37
const Attack = {DAMAGE = 10, KNOCKBACK = Vector2(200, -90), TYPE = "polygon", POINTS = PoolVector2Array([Vector2(-20, -12), Vector2(18, -3), Vector2(28, 1), Vector2(34, 6), Vector2(34, 11), Vector2(23, 13), Vector2(5, 10), Vector2(-10, 2)])}

var draw_hp

func _ready():
	experience_yield = 5
	hp = 25
	max_hp = hp
	draw_hp = hp
	state = "chase"
	$AnimatedSprite.play("walk")

func _process(delta):
	var friction = true
	
	match state:
		"idle":
			if has_node("/root/World/Player"):
				state = "chase"
				$AnimatedSprite.play("idle")
				$AnimatedSprite.offset.x = -3 * dir
		"chase":
#			execute only if player exists
			if has_node("/root/World/Player"):
				dir = (get_node("/root/World/Player").position.x - position.x) / abs(get_node("/root/World/Player").position.x - position.x)
				$AnimatedSprite.flip_h = false if dir > 0 else true
				
				var distance_to_player = position.distance_to(get_node("/root/World/Player").position)
				if distance_to_player <= ATTACK_RANGE:
					state = "attack"
					$AnimatedSprite.play("attack")
					$AnimatedSprite.offset.x = 16 * dir
					$Hitbox.setup(Attack, dir)
				else:
					motion.x = WALK_SPEED if $AnimatedSprite.flip_h == false else -WALK_SPEED
					$AnimatedSprite.offset.x = -3 * dir
					friction = false
			else:
				state = "idle"
				$AnimatedSprite.play("idle")
				$AnimatedSprite.offset.x = -3 * dir
		"attack":
			if frame_in_range(4, 5):
				$Hitbox.set_physics_process(true)
			else:
				$Hitbox.set_physics_process(false)
		"knockback":
			if motion.x < 1:
				state = "chase"
				$AnimatedSprite.play("idle")
				$AnimatedSprite.offset.x = -3 * dir
		"death":
			$AnimatedSprite.modulate.a -= 1 / 1.2 * delta
			$HealthBar.modulate.a -= 1 / 1.2 * delta
	
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
		state = "chase"
		$AnimatedSprite.play("walk")
		$AnimatedSprite.offset.x = -3 * dir
	elif state == "death":
		queue_free()