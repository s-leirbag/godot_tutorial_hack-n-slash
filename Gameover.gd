extends Node

func _ready():
	var save_file = File.new()
	save_file.open("user://save_game.save", File.READ)
	var content = parse_json(save_file.get_line())
	$KillsLabel.text = str("Kills: ", content.kills)
	save_file.close()