# Hitbox.gd
extends Area2D

var SkeletonBones = load("res://SkeletonBones.tscn")
var ParticleEmitterScene = load("res://ParticleEmitter.tscn")

var owner_path
var enemy_group
var damage = 1
var knockback = 4
var hit
var rng = RandomNumberGenerator.new()

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
		set_position(Vector2(info.X * dir, info.Y))
		
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
#		and body is not in an invulnerable state
#		and body isn't already hit
		if body.is_in_group(enemy_group) and not is_owner(body) and not body.invulnerable and hit.find(body) == -1:
			if body.name == "Player":
				get_node("/root/World/Camera2D").add_screenshake(20)
				
#				if player is killed
				if body.hp - damage <= 0:
					print("==")
					
					rng.randomize()
					for frame in range(10): # 10 is number of skeleton bones
						var bone = SkeletonBones.instance()
						bone.get_node("AnimatedSprite").frame = frame
						bone.set_position(body.position + Vector2(rng.randi_range(-8, 8), rng.randi_range(-24, 8)))
						var direction = deg2rad(-90 + body.dir * rng.randi_range(0, 60))
						var speed = rng.randi_range(200, 350)
						bone.motion = speed * Vector2(cos(direction), sin(direction))
						
						if frame == 5:
							bone.set_rotation_degrees(160)
						else:
							bone.set_rotation_degrees(rng.randi_range(1, 360))
						
						get_tree().get_current_scene().add_child(bone)
						
#						for debugging
						print(bone.get_node("AnimatedSprite").frame)
#						BUG FOUND! THIS BONE LOOP HAPPENS TWICE
					
					for node in hit:
						print(node.name)
			else:
				body.get_node("HealthBar").visible = true
				body.get_node("HealthBarTimer").start()
				
				get_node("/root/World/Camera2D").add_screenshake(3)
				
#				if killed by the player, increment kills
				if body.hp - damage <= 0:
					get_parent().kills += 1
			
			body.take_hit(damage, knockback, -1 if get_parent().position.x < body.position.x else 1) # new_dir can also be -get_parent().dir, but this may be better
#			particle effect
			var particle_emitter = ParticleEmitterScene.instance()
			get_node("/root/World").add_child(particle_emitter)
			particle_emitter.setup(body.position.x + body.dir * 4, body.position.y)
			
#			add body to list of hit bodies
			hit.push_back(body)

func is_owner(node):
	return node.get_path() == owner_path