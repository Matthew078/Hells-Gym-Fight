extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var screen_size 

export var speed = 400

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	


func _physics_process(delta):
	move()

func move():
	if Input.is_action_pressed("gym_bro_move_right"):
		apply_central_impulse(Vector2(4, 0))
		
	elif Input.is_action_pressed("gym_bro_move_left"):
		apply_central_impulse(Vector2(-4, 0))
	else:
		$AnimatedSprite.animation = 'standing'
		$AnimatedSprite.play()
	
		
	
