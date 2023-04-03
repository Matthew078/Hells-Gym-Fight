extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var screen_size 


export var speed = 200
var health = 100
var demon_punch = preload('res://PunchHitBoxDemon.tscn').instance()
var punch_hitbox = preload("res://PunchHitBox.tscn").instance()

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):

func _process(delta):
	
	$AnimatedSprite.play()
	var velocity = Vector2.ZERO # The player's movement vector.
	if $KnockedTimer.is_stopped():
		if Input.is_action_pressed("demon_move_right"):
			velocity.x += 1
		if Input.is_action_pressed("demon_move_left"):
			velocity.x -= 1
		if Input.is_action_pressed("demon_punch"):
			$PunchTimer.start()
		
		if Input.is_action_just_pressed("demon_fire"):
			$FireTimer.start()

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
		get_tree().change_scene("res://PlayerWins.tscn")
		
	if not $PunchTimer.is_stopped():
		self._punch()
	elif not $KnockedTimer.is_stopped():
		$AnimatedSprite.animation = "out"
	elif not $FireTimer.is_stopped():
		self._fire()
	else:
		$DemonHitBox/CollisionShape2D.disabled = true


func _punch():
	$AnimatedSprite.animation = "punch"
	$DemonHitBox/CollisionShape2D.disabled = false
func _fire():
	$AnimatedSprite.animation = "fire"
	$DemonHitBox/CollisionShape2D.disabled = false


func _on_DemonHurtBox_area_entered(area):
	if area.name == "PlayerHitBox":
		self.health -= 10
		$DemonHealthBar/HealthBar.value = health
		print(health)	
		$KnockedTimer.start()
