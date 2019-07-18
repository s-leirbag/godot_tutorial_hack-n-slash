extends Area2D

var owner_path
export(int) var damage = 1
export(int) var knockback = 4

func _ready():
	set_physics_process(false)

func setup(info, dir, param_owner_path, param_damage, param_knockback):
	position.x = info.X * dir
	position.y = info.Y
	$CollisionShape2D.shape.extents.x = info.WIDTH
	$CollisionShape2D.shape.extents.y = info.HEIGHT
	owner_path = param_owner_path
	damage = param_damage
	knockback = param_knockback

func _physics_process(delta):
	var overlapping_bodies = get_overlapping_bodies()
	if overlapping_bodies:
		for body in overlapping_bodies:
			if not is_owner(body):
				body.take_hit(damage, knockback)

#			if body.is_in_group("characters") and not is_owner(body):
#				body.take_hit(damage, knockback)
				
func is_owner(node):
	return node.get_path() == owner_path