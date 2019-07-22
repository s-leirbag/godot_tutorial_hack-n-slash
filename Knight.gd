# Knight.gd
extends "res://Character.gd"

# Movement constants
const WALK_SPEED = 20
const ATTACK_RANGE = 37

# Weapon constants
const Attack = {DAMAGE = 10, KNOCKBACK = Vector2(200, 0), TYPE = "polygon", X = -3, Y = -4, POINTS = PoolVector2Array([Vector2(-17, -8), Vector2(21, 1), Vector2(31, 5), Vector2(37, 10), Vector2(37, 15), Vector2(26, 17), Vector2(8, 14), Vector2(-7, 6)])}

func _ready():
	max_hp = 25
	hp = 25
	state = "chase"
	$AnimatedSprite.play("walk")

func _process(delta):
	var friction = true
	
	match state:
		"idle":
			if get_parent().has_node("Player"):
				state = "chase"
				$AnimatedSprite.play("idle")
				$AnimatedSprite.offset.x = -4 * dir
		"chase":
#			execute only if player exists
			if get_parent().has_node("Player"):
				dir = (get_parent().get_node("Player").position.x - position.x) / abs(get_parent().get_node("Player").position.x - position.x)
				$AnimatedSprite.flip_h = false if dir > 0 else true
				
				var distance_to_player = position.distance_to(get_parent().get_node("Player").position)
				if distance_to_player <= ATTACK_RANGE:
					state = "attack"
					$AnimatedSprite.play("attack")
					$AnimatedSprite.offset.x = 16 * dir
					$Hitbox.setup(Attack, dir, get_path())
				else:
					motion.x = WALK_SPEED if $AnimatedSprite.flip_h == false else -WALK_SPEED
					$AnimatedSprite.offset.x = -4 * dir
					friction = false
			else:
				state = "idle"
				$AnimatedSprite.play("idle")
				$AnimatedSprite.offset.x = -4 * dir
		"attack":
			if frame_in_range(4, 5):
				$Hitbox.set_physics_process(true)
			else:
				$Hitbox.set_physics_process(false)
		"knockback":
			if motion.x < 1:
				state = "chase"
				$AnimatedSprite.play("idle")
				$AnimatedSprite.offset.x = -4 * dir
	
	if friction == true:
		motion.x = lerp(motion.x, 0, 0.2)
#		for jumps
#		if is_on_floor():
#			motion.x = lerp(motion.x, 0, 0.2)
#		else:
#			motion.x = lerp(motion.x, 0, 0.05)
	
	motion = move_and_slide(motion, UP)

func _on_AnimatedSprite_animation_finished():
	if state == "attack":
		state = "chase"
		$AnimatedSprite.play("walk")
		$AnimatedSprite.offset.x = -4 * dir