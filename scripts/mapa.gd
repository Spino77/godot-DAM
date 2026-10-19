extends TileMapLayer

#generated the noise that will be used for the procedural map generation
var noise := FastNoiseLite.new()
var blocks = 0
#preload instances to be used later on
var player = preload("res://escenas/jugador.tscn")
var dun_entr = preload("res://escenas/entrada_mazmorra.tscn")
var rng = RandomNumberGenerator.new()
var dungeon_distance = 50

#starting function that generated the "seed" for the map generation
#as well as calling the functions that generate the map and instanciate the player
func _ready():
	randomize()
	noise.seed = randi()
	generateMap()
	generateplayer()
	
func generateplayer():
	var j = player.instantiate()
	add_child(j)
	j.position = Vector2i(16, -64)

func generateMap():
	#lenght of the map
	for x in 500:
		#noise value for the floor
		var floor = abs(noise.get_noise_2d(x,0) * 15)
		#height of the map
		for y in range(-200,200):
			#fills the map area with "sky" blocks, which will then be replaced by dirt or grass
			set_cell(Vector2i(x,y),2,Vector2i(0,0))
		for y in range(floor, 160):
			var noiseVal :float= abs(noise.get_noise_2d(x,y))
			if noiseVal < 0.4:
				#places grass
				if y in range(floor, floor + 2):
					set_cell(Vector2i(x,y),1,Vector2i(0,0))
					#spawns every few blocks a dungeon entrance
					if (dungeon_distance > 80 || dungeon_distance < 30):
							dungeon_distance = 50 
					if (x % dungeon_distance == 0):
						dungeon_distance += randi_range(0, 15)
						dungeon_distance -= randi_range(0, 15)
						var entrance = dun_entr.instantiate()
						add_child(entrance)
						entrance.position = Vector2i(x * 16, (floor * 16) - 64)
				#places dirt
				else:
					set_cell(Vector2i(x,y),1,Vector2i(1,0))

#code for breaking and placing blocks
#func _physics_process(delta: float) -> void:
	#if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		#var mouse_pos: Vector2 = get_global_mouse_position()
		#var local_pos: Vector2 = to_local(mouse_pos)
		#var tile_pos: Vector2i = local_to_map(local_pos)
		#if get_cell_source_id(tile_pos) == 1:
			#blocks += 1
		#erase_cell(tile_pos)
		#set_cell(tile_pos,2,Vector2i(0,0))
	#if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) and blocks > 0:
		#var mouse_pos: Vector2 = get_global_mouse_position()
		#var local_pos: Vector2 = to_local(mouse_pos)
		#var tile_pos: Vector2i = local_to_map(local_pos)
		#if get_cell_source_id(tile_pos) == 2:
			#set_cell(tile_pos,1,Vector2i(1,0))
			#blocks -= 1
