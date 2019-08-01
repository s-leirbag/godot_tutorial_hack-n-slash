extends Node2D

var gravity
var motion

func setup(pos, speed, direction, dir_offset, param_gravity, lifetime, frame):
	position = pos
	$AnimatedSprite.frame = frame
	$AnimatedSprite.rotation_degrees = direction + dir_offset
	direction = deg2rad(direction)
	motion = speed * Vector2(cos(direction), sin(direction))
	gravity = param_gravity
	
	$ParticleTimer.start(lifetime)

func _process(delta):
	position += motion * delta
	
	if gravity:
		motion.y += 2000 * delta

func _on_ParticleTimer_timeout():
	queue_free()