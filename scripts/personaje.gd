extends CharacterBody2D

var velocidad = 300.0
var velocidad_salto = -350.0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("saltar") and is_on_floor():
		velocity.y = velocidad_salto

	var direction := Input.get_axis("mov_izquierda", "mov_derecha")
	if direction:
		velocity.x = direction * velocidad
	else:
		velocity.x = move_toward(velocity.x, 0, velocidad)

	move_and_slide()
