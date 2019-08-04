extends Node

var Knight = load("res://Knight.tscn")
var Crow = load("res://Crow.tscn")
var Boss = load("res://Boss.tscn")

var rng

func _ready():
	rng = RandomNumberGenerator.new()
	
#	clear save file, store an empty dict
	var save_file = File.new()
	save_file.open("user://save_game.save", File.WRITE)
	save_file.seek(0) # this line necessary????
	save_file.store_line(to_json({}))
	save_file.close()

func _process(delta):
	var enemies = get_tree().get_nodes_in_group("enemies")

	if has_node("Player") and enemies.size() <= 5 and enemies.size() <= get_node("Player").kills / 2:
		rng.randomize()
		
#		find if a boss exists
		var boss_exists = false
		for enemy in enemies:
			if enemy.filename == "res://Boss.tscn":
				boss_exists = true
		
#		choose type of enemy
		var enemy
		if get_node("Player").kills > 20 and not boss_exists:
			var rand = rng.randi_range(1, 5)
			if rand == 1 or rand == 2:
				enemy = Knight.instance()
			elif rand == 3 or rand == 4:
				enemy = Crow.instance()
			else:
				enemy = Boss.instance()
		else:
			enemy = Knight.instance() if rng.randi_range(1, 3) == 1 else Crow.instance()
		
#		set enemy position
		if get_node("Player").position.x - 220 < -128:
			enemy.position.x = rng.randi_range(floor(get_node("Player").position.x) + 220, 640 + 128)
		elif get_node("Player").position.x + 220 > 640 + 128:
			enemy.position.x = rng.randi_range(-128, floor(get_node("Player").position.x) - 220)
		else:
			enemy.position.x = rng.randi_range(-128, floor(get_node("Player").position.x) - 220) if rng.randi_range(1, 2) == 1 else rng.randi_range(floor(get_node("Player").position.x) + 220, 640 + 128)
		
		if enemy.filename == "res://Knight.tscn":
			enemy.position.y = 272
		elif enemy.filename == "res://Boss.tscn":
			enemy.position.y = 254
		else:
			enemy.position.y = get_node("Player").position.y + rng.randi_range(-7, 7)
		
#		for debugging
#		print(str("spawned at x: ", enemy.position.x, " y: ", enemy.position.y))

		add_child(enemy)

func _on_Player_game_over():
#	TODO: stop processing
	$GameoverTimer.start()

func _on_GameoverTimer_timeout():
	get_tree().change_scene("res://Gameover.tscn")