extends VBoxContainer

#@export var health_potion: SwiftItemData = preload("res://items/health_potion.tres")
@export var axe: SwiftItemData = preload("res://items/axe.tres")
@export var longsword: SwiftItemData = preload("res://items/longsword.tres")
@export var shortsword: SwiftItemData = preload("res://items/short_sword.tres")
@export var mace: SwiftItemData = preload("res://items/mace.tres")

@onready var chest_grid: SwiftGrid = $PanelContainer/MarginContainer/SwiftGrid


func _ready() -> void:
	var item_list = []
	#item_list.append(health_potion)
	item_list.append(axe)
	item_list.append(longsword)
	item_list.append(shortsword)
	item_list.append(mace)
	var item_num = randi_range(1,4) #here use a random when using more than 1 item 
	var item_stack = randi_range(1,1)
	var chest_grid := chest_grid.swift_inventory
	chest_grid.try_add(item_list[item_num - 1], item_stack)
	chest_grid.try_move(0, randi_range(0,8), item_stack)
