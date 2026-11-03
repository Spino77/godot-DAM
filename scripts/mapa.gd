extends TileMapLayer

#name of the world to save to file
var worldName = "test1"

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
	readFile()
	#generateMap()
	generateplayer()
	saveToFile()
	
func _physics_process(delta: float):
	#var coords = tilemaplayer.local_to_map()
	pass


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
				#places dirt
				else:
					set_cell(Vector2i(x,y),3,Vector2i(randi_range(0,1),randi_range(0,1)))

##SAVE MAP TO FILE AND LOAD

func saveToFile():
	#file to save
	var save_file_path = "res://" + worldName + ".txt"
	var array = get_tile_map_data_as_array()
	var write_to_file = FileAccess.open(save_file_path, FileAccess.WRITE)
	write_to_file.store_buffer(array)

func readFile():
	var save_file_path = "res://" + worldName + ".txt"
	var array = FileAccess.get_file_as_bytes(save_file_path)
	set_tile_map_data_from_array(array)
