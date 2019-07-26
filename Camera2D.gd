extends Camera2D

func _process(delta):
	if get_parent().has_node("Player"):
		var new_pos = get_parent().get_node("Player").get_position()
		if new_pos.x < limit_left + 160:
			new_pos.x = limit_left + 160
		elif new_pos.x > limit_right - 160:
			new_pos.x = limit_right - 160
		if new_pos.y < limit_top + 90:
			new_pos.y = limit_top + 90
		elif new_pos.y > limit_bottom - 90:
			new_pos.y = limit_bottom - 90
		set_position(new_pos)