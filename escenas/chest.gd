extends Node2D

var is_open = false
var player_near
@onready var chest_inventory = $Chest_Inventory

func _ready() -> void:
	chest_inventory.hide()

func _physics_process(delta: float) -> void:
	if (Input.is_action_just_pressed("interact") and player_near):
		if is_open:
			chest_inventory.hide()
			is_open = false
		elif !is_open:
			chest_inventory.show()
			is_open = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Personaje":
		player_near = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Personaje":
		player_near = false
		if is_open:
			chest_inventory.hide()
			is_open = false
