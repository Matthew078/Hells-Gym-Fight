extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var screen_size 

var health = 100


const punch_damage = 15
const kick_damage = 25



var punching = false
export var speed = 200
var demon_punch = preload('res://PunchHitBoxDemon.tscn').instance()
var punch_hitbox = preload("res://PunchHitBox.tscn").instance()
var HealthBar = preload("res://HumanHealthBar.tscn").instance()
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	
	
func health_bar():
	HealthBar.get_child(0).value = health
	
	

func _physics_process(delta):
	#move()
	pass


		
func _punch():
	$AnimatedSprite.animation = "punch"
	punch_hitbox.position = $PunchHitBoxPosition.global_position
	
func _kick():
	$AnimatedSprite.animation = "kick"
	

func _process(delta):
	
	self.health_bar()
	$AnimatedSprite.play()
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("gym_bro_move_right"):
		velocity.x += 1
	if Input.is_action_pressed("gym_bro_move_left"):
		velocity.x -= 1
	
	if Input.is_action_just_pressed("gym_bro_punch"):
		$PunchTimer.start()
		$PunchSound.play()
		punching = true
	if Input.is_action_just_pressed("gym_bro_kick"):
		$KickTimer.start()
		$KickSound.play()
		

	velocity = velocity.normalized() * speed
	
		
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	
	if not $KnockedTimer.is_stopped():
		$AnimatedSprite.animation = "out"
	elif not $PunchTimer.is_stopped():
		self._punch()
	elif not $KickTimer.is_stopped():
		self._kick()
	else:
		punch_hitbox.position.y = -100
		
		if velocity.x != 0:
			$AnimatedSprite.animation = "walk"
			$AnimatedSprite.flip_v = false
			# See the note below about boolean assignment.
			$AnimatedSprite.flip_h = velocity.x < 0
		else:
			$AnimatedSprite.animation = "standing"
	#print(punch_hitbox.position)

func _on_player_area_entered(area):
	if area == demon_punch:
		self.health -= 10
		print(health)


func _on_player_body_entered(body):
	self.health -= 10
	$KnockedTimer.start()
	
