extends Node

func _ready():
	var save_file = File.new()
	save_file.open("user://save_game.save", File.READ)
	var content = parse_json(save_file.get_line())
	$KillsLabel.text = str("Kills: ", content.score)
	$HighscoreLabel.text = str("Highscore: ", content.highscore)
	save_file.close()

func _process(delta):
#	press key to restart game
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene("res://World.tscn")