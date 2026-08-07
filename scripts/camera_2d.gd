extends Camera2D

func _process(delta: float):
	var direction: Vector2 = Input.get_vector("mov_izquierda", "mov_derecha", "mov_arriba", "mov_abajo") 
	position += direction * 10
	if Input.is_action_just_released("scroll_arriba"):
		zoom += Vector2(0.1,0.1)
	if Input.is_action_just_released("scroll_abajo"):
		zoom -= Vector2(0.1,0.1)
