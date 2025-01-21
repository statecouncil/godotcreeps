extends Area2D

signal hit

@export var speed = 400
var screen_size


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size # set virtual game screen size to size of game window
	hide()


func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO # sets movement vector to zero
	# maps input keys to velocities
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed # makes sure diagonal movement is not faster than straight movement by limiting it to speed var
		$AnimatedSprite2D.play() # $ is shorthand for get_node()
	else:
		$AnimatedSprite2D.pause()
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size) # limits position of player to be within screen_size boundaries
	
	# directional animation fix-ups
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0 # if x velocity negative, flip sprite horizontally
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0 # if y velocity negative, flip sprite vertically


func _on_body_entered(_body: Node2D) -> void:
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true) # disabling collision needs to be delayed to end of frame to prevent collision errors
