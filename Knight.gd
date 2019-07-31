# Knight.gd
extends "res://Character.gd"

# Constants
const WALK_SPEED = 20
const ATTACK_RANGE = 37
const Attack = {DAMAGE = 10, KNOCKBACK = Vector2(200, -90), TYPE = "polygon", X = -3, Y = -4, POINTS = PoolVector2Array([Vector2(-17, -8), Vector2(21, 1), Vector2(31, 5), Vector2(37, 10), Vector2(37, 15), Vector2(26, 17), Vector2(8, 14), Vector2(-7, 6)])}

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
			get_node("/root/World/Player").kills += 1
			queue_free()
	
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