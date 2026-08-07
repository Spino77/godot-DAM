extends TileMapLayer

var ruido := FastNoiseLite.new()

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
