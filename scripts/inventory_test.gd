extends VBoxContainer

@export var health_potion: SwiftItemData = preload("res://items/health_potion.tres")
@onready var player_grid: SwiftGrid = $PanelContainer/MarginContainer/SwiftGrid


func _ready() -> void:
	var player_grid := player_grid.swift_inventory
	player_grid.try_add(health_potion, 252)
