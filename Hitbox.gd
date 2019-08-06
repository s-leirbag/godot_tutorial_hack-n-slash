# Hitbox.gd
extends Area2D

var owner_path
var enemy_group
var damage = 1
var knockback = 4
var hit

func _ready():
	set_physics_process(false)
	owner_path = get_parent().get_path()
	enemy_group = "enemies" if get_parent().is_in_group("player") else "player"

func setup(info, dir):
	damage = info.DAMAGE
	knockback = info.KNOCKBACK
	
#	stores bodies already hit
	hit = []
	
#	get rid of old collision shape
	if get_child(0):
		get_child(0).free()
	
#	make new collision shape
#	polygon or rectangle
	if info.TYPE == "polygon":
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
#		if body is an enemy
#		and body is not this hitbox's owner
#		and body is not dead
#		and body is not in knockback state
#		and body is not invulnerable
#		and body isn't already hit
		if body.is_in_group(enemy_group) and not is_owner(body) and not body.state == "death" and not body.state == "knockback" and not body.invulnerable and hit.find(body) == -1:
#			screenshake
			if body.name == "Player":
				get_node("/root/World/Camera2D").add_screenshake(20)
				
#				for debugging the duplicate bones glitch
				if body.hp - damage <= 0:
					for node in hit:
						print(node.name)
			elif body.filename == "res://Knight.tscn" or body.filename == "res://Crow.tscn":
				get_node("/root/World/Camera2D").add_screenshake(3)
			elif body.filename == "res://Boss.tscn":
				get_node("/root/World/Camera2D").add_screenshake(10)
			
#			add body to list of hit bodies
			hit.push_back(body)
			
			get_node("/root/World/Sounds/MediumHit").play()
			
#			particle effect
			var particle_emitter = Globals.ParticleEmitterScene.instance()
			particle_emitter.setup(0, 10, body.position.x + body.dir * 4, body.position.y)
			get_node("/root/World").add_child(particle_emitter)
			
			body.take_hit(damage, knockback, -1 if get_parent().position.x < body.position.x else 1) # new_dir can also be -get_parent().dir, but this may be better

func is_owner(node):
	return node.get_path() == owner_path