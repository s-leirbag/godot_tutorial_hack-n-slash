extends Node2D

var flashing = false
var flag = false

func _ready():
	var save_file = File.new()
	save_file.open("user://save_game.save", File.READ)
	var content = parse_json(save_file.get_line())
	$KillsLabel.text = str("Kills: ", content.score)
	$HighscoreLabel.text = str("Highscore: ", content.highscore)
	save_file.close()
	
	modulate = Color(0, 0, 0, 1)
	$RestartLabelTimer.start(2)

func _process(delta):
#	fade in
	if modulate.r < 1:
		modulate.r += delta
		
		if modulate.r > 1:
			modulate.r = 1
			modulate.g = 1
			modulate.b = 1
		else:
			modulate.g += delta
			modulate.b += delta
		
#		press key to restart game
		if Input.is_action_just_pressed("ui_accept"):
			get_tree().change_scene("res://World.tscn")
		
		if flashing:
			if flag:
				$RestartLabel.modulate.a -= 3 * delta
				if $RestartLabel.modulate.a <= 0:
					flag = not flag
					flashing = false
					$RestartLabelTimer.start(0.5)
			else:
				$RestartLabel.modulate.a += 3 * delta
				if $RestartLabel.modulate.a >= 1:
					flag = not flag
					flashing = false
					$RestartLabelTimer.start(0.5)

func _on_RestartLabelTimer_timeout():
	flashing = true
