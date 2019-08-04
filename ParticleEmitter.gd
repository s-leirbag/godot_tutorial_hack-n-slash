extends Node2D

var ParticleScene = load("res://Particle.tscn")

func setup(frame, count, x, y):
	position = Vector2(x, y)
	for i in range(count):
		emit_particle(frame)
	
	$EmitterTimer.start(0.5)

func emit_particle(frame):
	var spread = 4
	var pos = Vector2(rand_range(-spread, spread), rand_range(-spread, spread))
	var speed
	var direction
	var angle_offset
	var lifetime
	var gravity
	
	if frame == 0:
		speed = rand_range(300, 500)
		direction = rand_range(1, 360)
		angle_offset = 0
		lifetime = rand_range(0.1, 0.3)
		gravity = false
	else:
		speed = rand_range(200, 400)
		direction = rand_range(-110, -70)
		angle_offset = rand_range(0, 180)
		lifetime = 4
		gravity = true
	
	var particle = ParticleScene.instance()
	particle.setup(pos, speed, direction, angle_offset, gravity, lifetime, frame)
	add_child(particle)

func _on_EmitterTimer_timeout():
	queue_free()