extends Node2D

var test = false

func _ready():
	pass # Replace with function body.


func _process(delta: float):
	if Input.is_action_just_pressed("select") and test:
		get_tree().change_scene_to_file("res://escenas/dungeon.tscn")


func _on_area_entrada_body_entered(body):
	if body.name == "Personaje":
		test = true


func _on_area_entrada_body_exited(body: Node2D) -> void:
	if body.name == "Personaje":
		test = false
