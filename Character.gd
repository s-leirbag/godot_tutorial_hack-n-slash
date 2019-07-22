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

func take_hit(damage, knockback):
	hp -= damage
	if hp <= 0:
		queue_free()

func frame_in_range(low, high):
	return $AnimatedSprite.frame >= low and $AnimatedSprite.frame <= high