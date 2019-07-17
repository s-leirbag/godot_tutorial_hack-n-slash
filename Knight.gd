extends KinematicBody2D

const UP = Vector2(0, -1)
const WALK_SPEED = 20
const ATTACK_RANGE = 42

var motion = Vector2()
var state
var dir = 1

func _ready():
	state = "chase"
	$AnimatedSprite.play("walk")

func _physics_process(delta):
	motion.x = 0
	
	match state:
		"chase":
#			execute only if player exists
			if get_parent().has_node("Player"):
				dir = (get_parent().get_node("Player").position.x - position.x) / abs(get_parent().get_node("Player").position.x - position.x)
				$AnimatedSprite.flip_h = false if dir > 0 else true
				
				var distance_to_player = position.distance_to(get_parent().get_node("Player").position)
				if distance_to_player <= ATTACK_RANGE:
					state = "attack"
					$AnimatedSprite.play("attack")
					$AnimatedSprite.offset.x = 16 * dir
				else:
					motion.x = WALK_SPEED if $AnimatedSprite.flip_h == false else -WALK_SPEED
					$AnimatedSprite.offset.x = -4 * dir

	motion = move_and_slide(motion, UP)

func _on_AnimatedSprite_animation_finished():
	if state == "attack":
		state = "chase"
		$AnimatedSprite.play("walk")
		$AnimatedSprite.offset.x = -4 * dir
		
func take_hit(damage, knockback):
	queue_free()