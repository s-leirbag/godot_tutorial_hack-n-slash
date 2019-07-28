extends Node

var Knight = load("res://Knight.tscn")
var Crow = load("res://Crow.tscn")

var rng

func _ready():
	rng = RandomNumberGenerator.new()

func _process(delta):
	var num_enemies = get_tree().get_nodes_in_group("enemies").size()
	
	if has_node("Player") and num_enemies <= 5 and num_enemies <= get_node("Player").kills / 4:
		rng.randomize()
		var enemy = Knight.instance() if rng.randi_range(1, 3) == 1 else Crow.instance()

		var new_x = rng.randi_range(-128, floor(get_node("Player").position.x) - 220) if rng.randi_range(1, 2) == 1 else rng.randi_range(floor(get_node("Player").position.x) + 220, 640 + 128)
		
		enemy.position.x = new_x
		if enemy.filename == "res://Knight.tscn":
			enemy.position.y = 272
		else:
			enemy.position.y = get_node("Player").position.y #rng.randi_range(272 + 5, 272 - 5)
		
		add_child(enemy)