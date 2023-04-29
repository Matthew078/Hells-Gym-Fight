extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var screen_size 

var isKick = false
var isPunch = false
var leftright = false

export var speed = 200
var health = 100
var demon_punch = preload('res://punchhitboxdemon.tscn').instance()
var punch_hitbox = preload("res://punchhitbox.tscn").instance()

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
			self.scale = Vector2(-1.96, 2.12) 
		if Input.is_action_pressed("demon_move_left"):
			velocity.x -= 1
			self.scale = Vector2(1.96, 2.12) 
		if Input.is_action_pressed("demon_punch") and not self.isPunch and not self.isKick:
			self.isPunch = true
			$PunchTimer.start()
			$Punch.play()
		if Input.is_action_just_pressed("demon_fire") and not self.isPunch and not self.isKick:
			self.isKick = true
			$FireTimer.start()
			$Fire.play()

	velocity = velocity.normalized() * speed
	
	if $FireTimer.is_stopped():
		self.isKick = false
	
	if $PunchTimer.is_stopped():
		self.isPunch = false
	
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	
	
	if velocity.x != 0:
		$AnimatedSprite.animation = "walking"
		#$AnimatedSprite.flip_v = false
		# See the note below about boolean assignment.
		#$AnimatedSprite.flip_h = velocity.x > 0
	else:
		$AnimatedSprite.animation = "standing"

	if health <= 0:
		hide()
		get_tree().change_scene("res://playerwins.tscn")
		
	if not $PunchTimer.is_stopped():
		self._punch()
	elif not $KnockedTimer.is_stopped():
		$AnimatedSprite.animation = "out"
		if leftright:
			position.x += 40 * delta
		else:
			position.x -= 40 * delta
	elif not $FireTimer.is_stopped():
		self._fire()
	else:
		$DemonHitBox/CollisionShape2D.disabled = true


func _punch():
	$AnimatedSprite.animation = "punch"
	$DemonHitBox/CollisionShape2D.disabled = false
	$DemonHitBox.kicking = true
	$DemonHitBox.punching = false
func _fire():
	$AnimatedSprite.animation = "fire"
	$DemonHitBox/CollisionShape2D.disabled = false
	$DemonHitBox.kicking = false
	$DemonHitBox.punching = true


func _on_DemonHurtBox_area_entered(area):
	if area.name == "PlayerHitBox":
		
		if area.punching:
			self.health -= 10
		elif area.kicking:
			self.health -= 20
		$DemonHealthBar/HealthBar.value = health
		#print(health)	
		$KnockedTimer.start()
		
		if  area.get_parent().position.x - position.x < 0:
			leftright = true
		else:
			leftright = false
