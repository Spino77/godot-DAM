extends VBoxContainer

@export var health_potion: SwiftItemData = preload("res://items/health_potion.tres")
@onready var chest_grid: SwiftGrid = $PanelContainer/MarginContainer/SwiftGrid


func _ready() -> void:
	var item_list = []
	item_list.append(health_potion)
	var item_num = 1 #here use a random when using more than 1 item 
	var item_stack = randi_range(1,10)
	var chest_grid := chest_grid.swift_inventory
	chest_grid.try_add(item_list[item_num - 1], item_stack)
	chest_grid.try_move(0, randi_range(0,8), item_stack)
