extends Node2D

var ParticleScene = load("res://Particle.tscn")

func setup(x, y):
	position = Vector2(x, y)
	emit_particles(10)
	$LifeTimer.start(0.5)

func emit_particles(count):
	for i in range(count):
		var particle = ParticleScene.instance()
		add_child(particle)

#func _on_LifeTimer_timeout():
#	queue_free()