extends TileMapLayer

var ruido := FastNoiseLite.new()
var bloques = 0
var jugador = preload("res://escenas/jugador.tscn")
var dun_entr = preload("res://entrada_mazmorra.tscn")
var rng = RandomNumberGenerator.new()

func _ready():
	randomize()
	ruido.seed = randi()
	generateMap()
	generateJugador()
	
func generateJugador():
	var j = jugador.instantiate()
	add_child(j)
	j.position = Vector2i(16, -64)

func generateMap():
	for x in 400:
		var suelo = abs(ruido.get_noise_2d(x,0) * 15)
		for y in range(-200,200):
			set_cell(Vector2i(x,y),2,Vector2i(0,0))
		for y in range(suelo, 160):
			var noiseVal :float= abs(ruido.get_noise_2d(x,y))
			if noiseVal < 0.4:
				if y in range(suelo, suelo + 2):
					set_cell(Vector2i(x,y),1,Vector2i(0,0))
					var dungeon_pos_random = rng.randi_range(40, 80)
					if (x%dungeon_pos_random == 0):
						var entrance = dun_entr.instantiate()
						add_child(entrance)
						entrance.position = Vector2i(x * 16, y)
				else:
					set_cell(Vector2i(x,y),1,Vector2i(1,0))

#func _physics_process(delta: float) -> void:
	#if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		#var mouse_pos: Vector2 = get_global_mouse_position()
		#var local_pos: Vector2 = to_local(mouse_pos)
		#var tile_pos: Vector2i = local_to_map(local_pos)
		#if get_cell_source_id(tile_pos) == 1:
			#bloques += 1
		#erase_cell(tile_pos)
		#set_cell(tile_pos,2,Vector2i(0,0))
	#if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) and bloques > 0:
		#var mouse_pos: Vector2 = get_global_mouse_position()
		#var local_pos: Vector2 = to_local(mouse_pos)
		#var tile_pos: Vector2i = local_to_map(local_pos)
		#if get_cell_source_id(tile_pos) == 2:
			#set_cell(tile_pos,1,Vector2i(1,0))
			#bloques -= 1
