# Crow.gd
extends "res://Character.gd"

const Attack = {DAMAGE = 5, KNOCKBACK = Vector2(150, 0), TYPE = "rectangle", X = 1, Y = 4, WIDTH = 9, HEIGHT = 20}

# Called when the node enters the scene tree for the first time.
func _ready():
	experience_yield = 2
	hp = 1
	max_hp = hp
	state = "chase"
	motion.x = rng.randi_range(2, 3)
	if get_parent().has_node("Player"):
		motion.x = motion.x if get_parent().get_node("Player").position.x > position.x else -motion.x
		$AnimatedSprite.flip_h = false if motion.x > 0 else true
	
	$Hitbox.setup(Attack, motion.x / motion.x)

func _process(delta):
	match state:
		"chase":
			if get_parent().has_node("Player"):
				if $Hitbox.hit.find(get_parent().get_node("Player")) == -1:
					$Hitbox.set_physics_process(true)
				else:
					$Hitbox.set_physics_process(false)
					motion.y -= 0.2
	
#	if out of map's right, left, or top edge
	if position.x + $CollisionShape2D.shape.extents.x > 30 * 32 or position.x - $CollisionShape2D.shape.extents.x < -10 * 32 or position.y - $CollisionShape2D.shape.extents.y < 0:
		queue_free()
	
	motion = move_and_slide(motion)