# Character.gd
extends KinematicBody2D

var ExperienceScene = load("res://Experience.tscn")

# Movement constants
const UP = Vector2(0, -1)
const GRAVITY = 20

var hp
var max_hp
var state
var dir = 1
var motion = Vector2()
var invulnerable = false
var experience_yield

var rng

func _ready():
	rng = RandomNumberGenerator.new()

func take_hit(damage, knockback, new_dir):
	rng.randomize()
	hp -= damage
	if hp <= 0:
		queue_free()
		for i in range(min(experience_yield, 100)):
			var experience_instance = ExperienceScene.instance()
			experience_instance.set_position(position + Vector2(rng.randi_range(-4, 4), rng.randi_range(-4, 4)))
			get_parent().add_child(experience_instance)
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