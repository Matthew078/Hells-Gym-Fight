extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var screen_size 


export var speed = 200
export var health = 100
var gymbro_punch = preload('res://PunchHitBox.tscn').instance()
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):


func _process(delta):
	$AnimatedSprite.play()
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("demon_move_right"):
		velocity.x += 1
	if Input.is_action_pressed("demon_move_left"):
		velocity.x -= 1

	velocity = velocity.normalized() * speed
	
		
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	
	
	if velocity.x != 0:
		$AnimatedSprite.animation = "walking"
		$AnimatedSprite.flip_v = false
		# See the note below about boolean assignment.
		$AnimatedSprite.flip_h = velocity.x > 0
	else:
		$AnimatedSprite.animation = "standing"

	if health <= 0:
		hide()
	



func _on_demon_body_entered(body):
	#if body.name == "player":
	health -= 10
	print(health)	
