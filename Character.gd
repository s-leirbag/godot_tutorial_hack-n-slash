# Character.gd
extends KinematicBody2D

var ExperienceScene = load("res://Experience.tscn")
var ParticleEmitterScene = load("res://ParticleEmitter.tscn")

# Movement constants
const UP = Vector2(0, -1)
const GRAVITY = 1050

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
	hp -= damage
	if hp <= 0:
		state = "death"
#		make experience
		rng.randomize()
		for i in range(min(experience_yield, 100)):
			var experience_instance = ExperienceScene.instance()
			experience_instance.set_position(position + Vector2(rng.randi_range(-4, 4), rng.randi_range(-4, 4)))
			get_parent().add_child(experience_instance)
		
		if filename != "res://Player.tscn":
			get_node("/root/World/Player").kills += 1
#			$HealthBar.visible = false		# optional animation instead of have bar fade with enemy
#			$HealthBarTimer.queue_free()
			$Hitbox.set_process(false)
			
			if filename == "res://Knight.tscn":
				
				$AnimatedSprite.play("die")
				$AnimatedSprite.offset.x = -7 * dir
				$AnimatedSprite.flip_h = false if dir == 1 else true
			elif filename == "res://Crow.tscn":
		#		particle effect
				var particle_emitter = ParticleEmitterScene.instance()
				particle_emitter.setup(1, 4, 6, position.x + rand_range(-4, 4) + dir * 4, position.y + rand_range(-4, 4))
				get_node("/root/World").add_child(particle_emitter)
				queue_free()
	else:
		dir = new_dir
		state = "knockback"
		$AnimatedSprite.play("hitstun")
		$AnimatedSprite.offset.x = -7 * dir
		$AnimatedSprite.flip_h = false if dir == 1 else true
		$Hitbox.set_physics_process(false)
		motion = Vector2(knockback.x * -dir, knockback.y)
		
		if filename == "res://Knight.tscn" or filename == "res://Crow.tscn":
			$HealthBar.visible = true
			$HealthBarTimer.start()

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