extends Area2D

export(NodePath) var owner_path
export(int) var damage = 1
export(int) var knockback = 4

func _ready():
	set_physics_process(false)

func setup(param_owner_path, param_x, param_y, param_width, param_height, param_damage, param_knockback):
	owner_path = param_owner_path
	damage = param_damage
	knockback = param_knockback
	position.x = param_x
	position.y = param_y
	$CollisionShape2D.shape.extents.x = param_width
	$CollisionShape2D.shape.extents.y = param_height

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