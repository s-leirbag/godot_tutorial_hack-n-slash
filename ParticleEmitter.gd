extends Node2D

var ParticleScene = load("res://Particle.tscn")

func setup(frame, spread, count, x, y):
	position = Vector2(x, y)
	for i in range(count):
		emit_particle(frame, spread)
	
	$EmitterTimer.start(0.5)

func _process(delta):
	if Input.is_action_just_pressed("ui_focus_next"):
		var frame = 1
		var spread = 4
		var count = 6
		for i in range(count):
			emit_particle(frame, spread)

func emit_particle(frame, spread):
	var pos = Vector2(rand_range(-spread, spread), rand_range(-spread, spread))
	var speed
	var direction
	var angle_offset
	var lifetime
	var gravity
	
	if frame == 0:
		speed = rand_range(5, 10)
		direction = rand_range(1, 360)
		angle_offset = 0
		lifetime = rand_range(0.1, 0.3)
		gravity = false
	else:
		speed = rand_range(5, 8)
		direction = rand_range(-110, -70)
		angle_offset = rand_range(0, 180)
		lifetime = rand_range(0.5, 1)
		gravity = true
	
	var particle = ParticleScene.instance()
	particle.setup(pos, speed, direction, angle_offset, gravity, lifetime, frame)
	add_child(particle)

func _on_EmitterTimer_timeout():
	queue_free()