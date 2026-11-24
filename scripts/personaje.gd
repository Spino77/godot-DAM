extends CharacterBody2D

#refer to other nodes
@onready var lbl_coords = $PlayerInterface/Label
@onready var inventory = $PlayerInterface/InventoryTest

#velocidad testing
var velocidad = 600.0
#velocidad normal
#var velocidad = 300.0

var velocidad_salto = -360.0
var max_saltos = 2
var saltos = 0
var debug_toggle = true
var inventory_open = false

func _ready() -> void:
	inventory.hide()

func _physics_process(delta: float) -> void:
	#checks if its on floor to reset the max jumps amount
	if not is_on_floor():
		velocity += get_gravity() * delta
	if is_on_floor():
		saltos = max_saltos
	#jumping code
	if Input.is_action_just_pressed("saltar"):
		if is_on_floor() or is_on_wall():
			velocity.y = velocidad_salto
			saltos -= 1
		elif saltos > 0:
			velocity.y = velocidad_salto
			saltos -= 1
	#Changes character direction depending on movement
	if Input.is_action_just_pressed("mov_derecha"):
		$SpritePersonaje.flip_h = 0
	if Input.is_action_just_pressed("mov_izquierda"):
		$SpritePersonaje.flip_h = 1
	#Movement
	var direction := Input.get_axis("mov_izquierda", "mov_derecha")
	if direction:
		velocity.x = direction * velocidad
	else:
		velocity.x = move_toward(velocity.x, 0, velocidad)
	move_and_slide()
	
	if debug_toggle == true:
		lbl_coords.text = str((global_position / 32).round())
	
	if Input.is_action_just_pressed("inventory"):
		if inventory_open:
			inventory.hide()
			inventory_open = false
		elif (!inventory_open):
			inventory.show()
			inventory_open = true
