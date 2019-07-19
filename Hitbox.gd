# Hitbox.gd
extends Area2D

var owner_path
var damage = 1
var knockback = 4

func _ready():
	set_physics_process(false)

func setup(info, dir, param_owner_path):
	owner_path = param_owner_path
	damage = info.DAMAGE
	knockback = info.KNOCKBACK
	
#	get rid of old collision shape
	if get_child(0):
		get_child(0).free()
	
#	make new collision shape
#	polygon or rectangle
	if info.TYPE == "polygon":
#		reset position if needed
		if get_position() != Vector2(0, 0):
			set_position(Vector2(0, 0))
		
#		make new CollisionPolygon2D
		var hitbox = CollisionPolygon2D.new()
		hitbox.set_name("CollisionPolygon2D")
		add_child(hitbox)
		
#		flip if needed
#		set polygon
		if dir == -1:
			var new_points = PoolVector2Array()
			for vect in info.POINTS:
				new_points.push_back(Vector2(-vect.x, vect.y))
			$CollisionPolygon2D.set_polygon(new_points)
		else:
			$CollisionPolygon2D.set_polygon(info.POINTS)
	elif info.TYPE == "rectangle":
		set_position(Vector2(info.X * dir, info.Y))
		
#		make new CollisionShape2D
		var hitbox = CollisionShape2D.new()
		hitbox.set_name("CollisionShape2D")
		add_child(hitbox)
		
#		set rectangle
		var shape = RectangleShape2D.new()
		$CollisionShape2D.set_shape(shape)
		$CollisionShape2D.shape.set_extents(Vector2(info.WIDTH, info.HEIGHT))

func _physics_process(delta):
#	loop through overlapping bodies
	for body in get_overlapping_bodies():
#		if body is a character
#		and body is not this hitbox's owner
		if body.is_in_group("characters") and not is_owner(body):
			body.take_hit(damage, knockback)

func is_owner(node):
	return node.get_path() == owner_path