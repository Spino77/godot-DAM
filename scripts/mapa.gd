extends Node2D

#variables for saving/loading
var world_name = "test1"
var entrance_pos_array = []
var generate_world = false

#generated the noise that will be used for the procedural map generation
var noise := FastNoiseLite.new()

#preload instances to be used later on
var player = preload("res://escenas/jugador.tscn")
var dun_entr = preload("res://escenas/dungeon_entrance.tscn")

@onready var mapa = $mapa

#numbers used for randomized generation
var rng = RandomNumberGenerator.new()
var dungeon_distance = 50

#starting function that generated the "seed" for the map generation
#as well as calling the functions that generate the map and instanciate the player
func _ready():
	randomize()
	noise.seed = randi()
	#uses "generate_world" var to check if it has to make a new world or load an existing one
	#maybe make the var global so it can be modified if "new world" or "load world" is chosen in main menu
	if generate_world:
		generateMap()
		saveToFile()
	elif !generate_world:
		readFile()
	generateplayer()

func generateplayer():
	var player = player.instantiate()
	add_child(player)
	player.position = GlobalVars.player_pos

func generateMap():
	#lenght of the map
	for x in 500:
		#noise value for the floor
		var floor = abs(noise.get_noise_2d(x,0) * 15)
		#height of the map
		for y in range(-200,200):
			#fills the map area with "sky" blocks, which will then be replaced by dirt or grass
			mapa.set_cell(Vector2i(x,y),5,Vector2i(randi_range(0,1),randi_range(0,1)))
		for y in range(floor, 160):
			var noiseVal :float= abs(noise.get_noise_2d(x,y))
			if noiseVal < 0.6:
				#places grass
				if y in range(floor, floor + 1):
					mapa.set_cell(Vector2i(x,y),4,Vector2i(randi_range(0,1),0))
					#spawns every few blocks a dungeon entrance
					if (dungeon_distance > 80 || dungeon_distance < 30):
							dungeon_distance = 50 
					if (x % dungeon_distance == 0):
						dungeon_distance += randi_range(0, 15)
						dungeon_distance -= randi_range(0, 15)
						var entrance = dun_entr.instantiate()
						mapa.add_child(entrance)
						entrance.position = Vector2i(x * 32, (floor * 32) - 64)
						#saves dungeon position as array to then save to file
						entrance_pos_array.append(str(entrance.position.x) + " | " + str(entrance.position.y) + " , ")
				#places dirt
				else:
					mapa.set_cell(Vector2i(x,y),3,Vector2i(randi_range(0,1),randi_range(0,1)))

#SAVE MAP TO FILE AND LOAD
func saveToFile():
	#save map
	var map_save_file_path = "res://" + world_name + ".txt"
	var dungeon_save_file_path = "res://" + world_name + "_dungeons.txt"
	
	var array = mapa.get_tile_map_data_as_array()
	var write_to_file_map = FileAccess.open(map_save_file_path, FileAccess.WRITE)
	write_to_file_map.store_buffer(array)
	
	#save positions of each dungeon
	var write_to_file_dungeon = FileAccess.open(dungeon_save_file_path, FileAccess.WRITE)
	for item in entrance_pos_array:
		write_to_file_dungeon.store_line(item)

func readFile():
	var map_save_file_path = "res://" + world_name + ".txt"
	var dungeon_save_file_path = "res://" + world_name + "_dungeons.txt"
	
	var array = FileAccess.get_file_as_bytes(map_save_file_path)
	mapa.set_tile_map_data_from_array(array)
	
	##NO FUNCIONA 
	##TODO SE TIENE QUE HACER ALGO PARA LEER EL "ARRAY" DE Vector2  
	
	var entrance_pos_array_load = FileAccess.get_file_as_string(dungeon_save_file_path)
	 
	for item in entrance_pos_array_load.split(" , "):
		var positions = item.split(" | ")
		var entrance = dun_entr.instantiate()
		mapa.add_child(entrance)
		entrance.position = Vector2i(positions.get(0).to_int(),positions.get(1).to_int())

#if Input.is_action_just_pressed("select") and GlobalVars.enter_allow:
	#var counter = 0
	#var index = 0
	#for item in entrance_pos_array:
		#if str(item) == GlobalVars.current_dung_pos:
			#index = counter
		#counter += 1
	#entrance_pos_array.remove_at(index)
	#saveToFile()
