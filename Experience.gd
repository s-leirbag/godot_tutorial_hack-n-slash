extends Area2D

var motion = Vector2()
var max_speed = 20

func _ready():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var direction = rng.randi_range(1, 360)
	var speed = rng.randi_range(5, max_speed)
	motion = speed * point_direction(Vector2(0, 0), Vector2(sin(direction), cos(direction)))

func _process(delta):
	position = position + motion
	
	var move_to_player = true
	for area in get_overlapping_areas():
		if area.filename == "res://Experience.tscn":
			motion = 2 * point_direction(area.get_position(), get_position())
			if move_to_player:
				move_to_player = false
	
	if move_to_player and get_parent().has_node("Player"):
		motion.x = lerp(motion.x, 2.5 * point_direction(get_position(), get_parent().get_node("Player").get_position()).x, 0.2)
		motion.y = lerp(motion.y, 2.5 * point_direction(get_position(), get_parent().get_node("Player").get_position()).y, 0.2)
		if motion.length() > max_speed:
			motion *= max_speed / motion.length()

func point_direction(pos1, pos2):
	var dir = Vector2()
	dir = pos2 - pos1
	return dir.normalized()

func _on_Experience_body_entered(body):
	if body.name == "Player":
		body.experience += 1
		if body.experience >= body.max_experience:
			body.level += 1
			body.experience -= body.max_experience
			body.max_experience *= 2
			
#			improve player stats
			body.max_hp += 5
			body.hp = body.max_hp
			body.strength += 5
		queue_free()