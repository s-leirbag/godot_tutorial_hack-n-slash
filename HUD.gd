extends Node2D

var draw_hp

func _ready():
	draw_hp = get_node("/root/World/Player").hp

func _process(delta):
	set_position(get_node("/root/World/Camera2D").get_camera_position() - Vector2(160, 90))
	
	var hp_percent
	if has_node("/root/World/Player"):
		draw_hp = lerp(draw_hp, get_node("/root/World/Player").hp, 0.2)
		hp_percent = float(draw_hp) / float(get_node("/root/World/Player").max_hp)
	else:
		draw_hp = 0
		hp_percent = 0
	$HealthBar.value = hp_percent * 100
	
	if has_node("/root/World/Player"):
		var text = str("Kills: ", get_node("/root/World/Player").kills)
		$KillsLabel.text = text
		text = str("Level: ", get_node("/root/World/Player").level)
		$LevelLabel.text = text