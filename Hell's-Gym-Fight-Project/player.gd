extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var screen_size 

export var speed = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	


func _physics_process(delta):
	#move()
	pass

func move():
	if Input.is_action_pressed("gym_bro_move_right"):
		apply_central_impulse(Vector2(4, 0))
		
	elif Input.is_action_pressed("gym_bro_move_left"):
		apply_central_impulse(Vector2(-4, 0))
	else:
		$AnimatedSprite.animation = 'standing'
		$AnimatedSprite.play()
		
		



func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("gym_bro_move_right"):
		velocity.x += 1
	if Input.is_action_pressed("gym_bro_move_left"):
		velocity.x -= 1
	
	if Input.is_action_just_pressed("gym_bro_punch"):
		print("punching")
		$Hitbox.disabled = false
		print($Hitbox.disabled)
	else:
		$Hitbox.disabled = true
		print($Hitbox.disabled)

	velocity = velocity.normalized() * speed
	$AnimatedSprite.play()
		
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		# See the note below about boolean assignment.
		$AnimatedSprite.flip_h = velocity.x < 0
	else:
		$AnimatedSprite.animation = "standing"

