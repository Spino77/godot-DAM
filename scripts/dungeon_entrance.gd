extends Node2D

var enter_allow = false

func _ready():
	pass

func _process(delta: float):
	if Input.is_action_just_pressed("select") and enter_allow:
		GlobalVars.player_pos = Vector2i(self.position.x, self.position.y)
		get_tree().change_scene_to_file("res://escenas/dungeon.tscn")
		queue_free()

	if position.x == 0:
		queue_free()

func _on_area_entrada_body_entered(body):
	if body.name == "Personaje":
		enter_allow = true

func _on_area_entrada_body_exited(body: Node2D) -> void:
	if body.name == "Personaje":
		enter_allow = false
