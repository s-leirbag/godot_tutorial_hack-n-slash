extends KinematicBody2D

var hp = 25
var max_hp

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func take_hit(damage, knockback):
	hp -= damage
	if hp <= 0:
		queue_free()

func frame_in_range(low, high):
	return $AnimatedSprite.frame >= low and $AnimatedSprite.frame <= high