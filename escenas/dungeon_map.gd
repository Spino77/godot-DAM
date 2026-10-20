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
	for x in 200:
		#noise value for the floor
		var floor = abs(noise.get_noise_2d(x,0) * 15)
		#height of the map
		for y in range(-200,200):
			#fills the map area with "sky" blocks, which will then be replaced by dirt or grass
			set_cell(Vector2i(x,y),1,Vector2i(randi_range(0,1),randi_range(0,1)))
		for y in range(-100, 100):
			var noiseVal :float= abs(noise.get_noise_2d(x,y))
			if y in range(-2, 2):
				set_cell(Vector2i(x,y),1,Vector2i(randi_range(0,1),randi_range(0,1)))
			else:
				if noiseVal < 0.4:
					#places grass
					set_cell(Vector2i(x,y),2,Vector2i(randi_range(0,1),randi_range(0,1)))
