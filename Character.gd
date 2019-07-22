# Character.gd
extends KinematicBody2D

# Movement constants
const UP = Vector2(0, -1)
#const GRAVITY = 20

var hp
var max_hp
var state
var dir = 1
var motion = Vector2()
var invulnerable = false

func take_hit(damage, knockback, new_dir):
	hp -= damage
	if hp <= 0:
		queue_free()
	else:
		dir = new_dir
		state = "knockback"
		$AnimatedSprite.play("hitstun")
		$AnimatedSprite.offset.x = -7 * dir
		$AnimatedSprite.flip_h = false if dir == 1 else true
		$Hitbox.set_physics_process(false)
		motion = knockback * -dir

func frame_in_range(low, high):
	return $AnimatedSprite.frame >= low and $AnimatedSprite.frame <= high

# a tween based on delta, not time
func approach(current, target, change):
	if current < target:
		current += change
		if current > target:
			current = target
	else:
		current -= change
		if current < target:
			current = target
	
	return current