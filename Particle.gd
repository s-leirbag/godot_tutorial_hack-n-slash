extends Node2D

var motion

func _ready():
	var speed = rand_range(5, 10)
	var direction = rand_range(1, 360)
	var lifetime = rand_range(0.1, 0.3)
	
	$Sprite.rotation_degrees = direction
	direction = deg2rad(direction)
	motion = speed * Vector2(cos(direction), sin(direction))
	
	$LifeTimer.start(lifetime)

func _process(delta):
	position += motion

func _on_LifeTimer_timeout():
	queue_free()