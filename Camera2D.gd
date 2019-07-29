extends Camera2D

var target_offset = Vector2()

# starts at player
func _ready():
	var player = get_node("/root/World/Player")
	position.x = player.position.x + player.dir * 32
	position.y = player.position.y

func _process(delta):
	if has_node("/root/World/Player"):
#		tween to new position
		var player = get_node("/root/World/Player")
		position.x = lerp(position.x, player.position.x + target_offset.x + player.dir * 32, 0.2)
		position.y = lerp(position.y, player.position.y + target_offset.y, 0.2)
		
#		keep in bounds
		if position.x < limit_left + 160:
			position.x = limit_left + 160
		elif position.x > limit_right - 160:
			position.x = limit_right - 160
		if position.y < limit_top + 90:
			position.y = limit_top + 90
		elif position.y > limit_bottom - 90:
			position.y = limit_bottom - 90

# start shake timer and endshake timer
func add_screenshake(intensity, duration):
	$ShakeTimer.set_paused(false)
	$ShakeTimer.start()
	$EndShakeTimer.start()

# make new offset to shake to
func _on_ShakeTimer_timeout():
	var intensity = 20
	target_offset = Vector2(rand_range(-intensity, intensity), -2 + rand_range(-intensity, intensity))

# reset offset and stop shaking
func _on_EndShakeTimer_timeout():
	$ShakeTimer.set_paused(true)
	target_offset = Vector2()
