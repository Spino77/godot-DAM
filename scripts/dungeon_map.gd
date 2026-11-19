extends TileMapLayer

#generated the noise that will be used for the procedural map generation
var blocks = 0
#preload instances to be used later on
var player = preload("res://escenas/jugador.tscn")
var dun_exit = preload("res://escenas/dungeon_exit.tscn")

#starting function that generated the "seed" for the map generation
#as well as calling the functions that generate the map and instanciate the player
func _ready():
	randomize()
	generateMap()
	spawnExit()
	generateplayer()

func generateplayer():
	var j = player.instantiate()
	add_child(j)
	j.position = Vector2i(816, 32)

func generateMap():
	#lenght of the map
	for x in 200:
		#noise value for the floor
		#height of the map
		for y in range(-200,200):
			#fills the map area with "sky" blocks, which will then be replaced by dirt or grass
			set_cell(Vector2i(x,y),1,Vector2i(randi_range(0,1),randi_range(0,1)))
		for y in range(-100, 100):
			if y in range(-2, 3) && x in range(20, 180):
				set_cell(Vector2i(x,y),1,Vector2i(randi_range(0,1),randi_range(0,1)))
			else:
				#places floor
				set_cell(Vector2i(x,y),2,Vector2i(randi_range(0,1),randi_range(0,1)))

func spawnExit():
	var entrance = dun_exit.instantiate()
	add_child(entrance)
	entrance.position = Vector2i(175 * 32, (3 * 32) - 64)
