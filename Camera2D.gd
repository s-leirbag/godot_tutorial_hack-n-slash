extends Camera2D

func _ready():
	pass # Replace with function body.

func _process(delta):
	if get_parent().has_node("Player"):
		set_position(get_parent().get_node("Player").get_position())