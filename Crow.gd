# Crow.gd
extends "res://Character.gd"

const Attack = {DAMAGE = 5, KNOCKBACK = Vector2(200, -90), TYPE = "rectangle", X = 1, Y = 4, WIDTH = 9, HEIGHT = 20}

var draw_hp

# Called when the node enters the scene tree for the first time.
func _ready():
	experience_yield = 2
	hp = 1
	max_hp = hp
	draw_hp = hp
	state = "chase"
	motion.x = rng.randi_range(75, 175)
	if get_parent().has_node("Player"):
		motion.x = motion.x if get_node("/root/World/Player").position.x > position.x else -motion.x
		$AnimatedSprite.flip_h = false if motion.x > 0 else true
		$AnimatedSprite.play("fly")
	
	$Hitbox.setup(Attack, motion.x / motion.x)

func _process(delta):
	match state:
		"chase":
			if has_node("/root/World/Player"):
				if $Hitbox.hit.find(get_node("/root/World/Player")) == -1:
					$Hitbox.set_physics_process(true)
				else:
					$Hitbox.set_physics_process(false)
					motion.y -= 100 * delta
	
#	if out of map's right, left, or top edge
	if position.x + $CollisionShape2D.shape.extents.x > 30 * 32 or position.x - $CollisionShape2D.shape.extents.x < -10 * 32 or position.y - $CollisionShape2D.shape.extents.y < 0:
		queue_free()
	
#	not move_and_slide because crow shouldn't collide with wall
	position += motion * delta
	
	var hp_percent
	draw_hp = lerp(draw_hp, hp, 0.2)
	hp_percent = float(draw_hp) / float(max_hp)
	$HealthBar.value = hp_percent * 100

func _on_HealthBarTimer_timeout():
	$HealthBar.visible = false
