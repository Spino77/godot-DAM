extends Node2D

var enter_allow = false

func _ready():
	pass

func _process(delta: float):
	if Input.is_action_just_pressed("select") and GlobalVars.enter_allow:
		GlobalVars.player_pos = Vector2i(self.position.x, self.position.y)
		#GlobalVars.current_dung_pos = (str(self.position.x) + " | " + str(self.position.y) + " , ")
		queue_free()
		get_tree().change_scene_to_file("res://escenas/dungeon.tscn")
	if position.x == 0:
		queue_free()

func _on_area_entrada_body_entered(body):
	if body.name == "Personaje":
		GlobalVars.enter_allow = true

func _on_area_entrada_body_exited(body: Node2D) -> void:
	if body.name == "Personaje":
		GlobalVars.enter_allow = false
