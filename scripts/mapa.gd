extends TileMapLayer

#variables to save
var world_name = "test1"
var entrance_pos_array = []

#generated the noise that will be used for the procedural map generation
var noise := FastNoiseLite.new()
var blocks = 0
#preload instances to be used later on
var player = preload("res://escenas/jugador.tscn")
var dun_entr = preload("res://escenas/dungeon_entrance.tscn")
var rng = RandomNumberGenerator.new()
var dungeon_distance = 50
@onready var tilemaplayer: TileMapLayer = $mapa

#starting function that generated the "seed" for the map generation
#as well as calling the functions that generate the map and instanciate the player
func _ready():
	randomize()
	noise.seed = randi()
	#readFile()
	generateMap()
	generateplayer()
	saveToFile()
	
func _physics_process(delta: float):
	saveToFile()


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
			set_cell(Vector2i(x,y),5,Vector2i(randi_range(0,1),randi_range(0,1)))
		for y in range(floor, 160):
			var noiseVal :float= abs(noise.get_noise_2d(x,y))
			if noiseVal < 0.6:
				#places grass
				if y in range(floor, floor + 1):
					set_cell(Vector2i(x,y),4,Vector2i(randi_range(0,1),0))
					#spawns every few blocks a dungeon entrance
					if (dungeon_distance > 80 || dungeon_distance < 30):
							dungeon_distance = 50 
					if (x % dungeon_distance == 0):
						dungeon_distance += randi_range(0, 15)
						dungeon_distance -= randi_range(0, 15)
						var entrance = dun_entr.instantiate()
						add_child(entrance)
						entrance.position = Vector2i(x * 32, (floor * 32) - 64)
						entrance_pos_array.append(Vector2i(x * 32, (floor * 32) - 64))
				#places dirt
				else:
					set_cell(Vector2i(x,y),3,Vector2i(randi_range(0,1),randi_range(0,1)))

##SAVE MAP TO FILE AND LOAD

func saveToFile():
	#save map
	var map_save_file_path = "res://" + world_name + ".txt"
	var dungeon_save_file_path = "res://" + world_name + "_dungeons.json"
	
	var array = get_tile_map_data_as_array()
	var write_to_file_map = FileAccess.open(map_save_file_path, FileAccess.WRITE)
	write_to_file_map.store_buffer(array)
	
	var write_to_file_dungeon = FileAccess.open(dungeon_save_file_path, FileAccess.WRITE)
	for item in entrance_pos_array:
		write_to_file_dungeon.store_line(JSON.stringify(item))
	
	
func readFile():
	var map_save_file_path = "res://" + world_name + ".txt"
	var dungeon_save_file_path = "res://" + world_name + "_dungeons.json"

	var array = FileAccess.get_file_as_bytes(map_save_file_path)
	set_tile_map_data_from_array(array)
	
	##NO FUNCIONA 
	##SE TIENE QUE HACER ALGO PARA LEER EL "ARRAY" DE Vector2  
	var dungeon_pos = FileAccess.get_file_as_string(dungeon_save_file_path)
	var array_dungeon_pos = str_to_var(dungeon_pos)
	print(array_dungeon_pos)
	
