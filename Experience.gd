extends Area2D

var direction
var speed
var motion = Vector2()

func _ready():
	var rng = RandomNumberGenerator.new()
	direction = rng.randi_range(1, 360)
	speed = rng.randi_range(3, 6)

func _process(delta):
	position = position + motion
	if get_parent().get_parent().has_node("Player"):
		var dir = point_direction(get_position(), get_parent().get_parent().get_node("Player").get_position())
		var acceleration = dir * 0.25
		motion = dir + acceleration

func point_direction(pos1, pos2):
	var dir = Vector2()
	dir = pos2 - pos1
	return dir.normalized()