extends Node2D

var draw_hp

func _ready():
	draw_hp = get_parent().get_node("Player").hp

func _process(delta):
	set_position(get_parent().get_node("Camera2D").get_camera_position() - Vector2(160, 90))
	
	var hp_percent
	if get_parent().has_node("Player"):
		draw_hp = lerp(draw_hp, get_parent().get_node("Player").hp, 0.2)
		hp_percent = float(draw_hp) / float(get_parent().get_node("Player").max_hp)
	else:
		draw_hp = 0
		hp_percent = 0
	$HealthBar.value = hp_percent * 100
	
	if get_parent().has_node("Player"):
		var text = str("Kills: ", get_parent().get_node("Player").kills)
		$KillsLabel.text = text
		text = str("Level: ", get_parent().get_node("Player").level)
		$LevelLabel.text = text