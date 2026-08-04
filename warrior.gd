extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -300.0

@onready var animationPlayer = $visual/AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
	animations(direction) # animaciones
	
	if direction == 1:
		animationPlayer.flip_h = false
		$visual.scale.x = 1
	elif direction == -1:
		animationPlayer.flip_h = true
		$visual.scale.x = -1
	
func animations(direction): # Animaciones del personaje
	if is_on_floor():
		if direction == 0:
			animationPlayer.play("ide")
		else:
			animationPlayer.play("run")
	else:
		if velocity.y<0:
			animationPlayer.play("jump")
		else:
			animationPlayer.play("fall")
