extends TileMapLayer

var ruido := FastNoiseLite.new()
var bloques = 0

func _ready():
	randomize()
	ruido.seed = randi()
	generateMap()

func generateMap():
	for x in 1200:
		var suelo = abs(ruido.get_noise_2d(x,0) * 15)
		for y in range(-200,200):
			set_cell(Vector2i(x,y),2,Vector2i(0,0))
		for y in range(suelo, 160):
			var noiseVal :float= abs(ruido.get_noise_2d(x,y))
			if noiseVal < 0.4:
				if y in range(suelo, suelo + 2):
					set_cell(Vector2i(x,y),1,Vector2i(0,0))
				else:
					set_cell(Vector2i(x,y),1,Vector2i(1,0))

func _physics_process(delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var mouse_pos: Vector2 = get_global_mouse_position()
		var local_pos: Vector2 = to_local(mouse_pos)
		var tile_pos: Vector2i = local_to_map(local_pos)
		if get_cell_source_id(tile_pos) == 1:
			bloques += 1
		erase_cell(tile_pos)
		set_cell(tile_pos,2,Vector2i(0,0))
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) and bloques > 0:
		var mouse_pos: Vector2 = get_global_mouse_position()
		var local_pos: Vector2 = to_local(mouse_pos)
		var tile_pos: Vector2i = local_to_map(local_pos)
		if get_cell_source_id(tile_pos) == 2:
			set_cell(tile_pos,1,Vector2i(1,0))
			bloques -= 1
		
