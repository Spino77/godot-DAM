extends TileMapLayer

var ruido := FastNoiseLite.new()

func _ready():
	randomize()
	ruido.seed = randi()
	generateMap()

func generateMap():
	for x in 100:
		for y in 100:
			var noiseVal :float= abs(ruido.get_noise_2d(x,y))
			if noiseVal < 0.25:
				set_cell(Vector2i(x,y),0,Vector2i(0,1))
