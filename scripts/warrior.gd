extends CharacterBody2D

@onready var animationPlayer = $AnimatedSprite2D
var isAttacking = false
var currentAttackDamage = 0.0

# --- Stats ---
const SPEED = 75.0
const JUMP_VELOCITY = -250.0
@export var max_health: float = 200.0
@export var defense: float = 10.0  
@export var damage1: float = 20.0
@export var damage2: float = 45.0
@export var crit_chance: float = 0.2 # 20% crítica
@export var crit_multiplier_min: float = 1.3  # x1.1 en golpe crítico
@export var crit_multiplier_max: float = 1.8  # x1.8 en golpe crítico

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("saltar") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("mov_izquierda", "mov_derecha")
	if isAttacking:
		velocity.x = 0 # congelar si ataca
	elif direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	move_and_slide()
	animations(direction) # animaciones
	
	if not isAttacking: # bloquear direccion si ataca
		if direction == 1: 
			$AnimatedSprite2D.flip_h = false
			# flip el attack box
			$attackArea.position.x = abs($attackArea.position.x)
		elif direction == -1:
			$AnimatedSprite2D.flip_h = true
			$attackArea.position.x = -abs($attackArea.position.x)
	
func animations(direction): # Animaciones del personaje
	if Input.is_action_just_pressed("attack") and not isAttacking:
		animationPlayer.play("attack")
		isAttacking = true
		$attackArea/CollisionShape2D.disabled = false
		return # no dejar que sobreescriba
	if Input.is_action_just_pressed("skill") and not isAttacking:
		animationPlayer.play("attack_2")
		isAttacking = true
		$attackArea/CollisionShape2D.disabled = false
		return # no dejar que sobreescriba
	
	if isAttacking: # mientras ataca, no tocar animacion desde aqui
		return  
	
	var onFloorNow = is_on_floor()

	if onFloorNow:
		if direction == 0:
			animationPlayer.play("ide")
		else:
			animationPlayer.play("run")
	else:
		if velocity.y < 0:
			animationPlayer.play("jump")
		else:
			animationPlayer.play("fall")


func _on_animated_sprite_2d_animation_finished():
	if animationPlayer.animation == "attack" or animationPlayer.animation == "attack_2":
		$attackArea/CollisionShape2D.disabled = true
		isAttacking = false # cambiar la variable a false cuando termine
