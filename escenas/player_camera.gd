extends Camera2D

@onready var label_coords = $Label
@onready var mapa = res://escenas/main.tscn/$mapa

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var actual_coords = null
	
	label_coords.text = str(floor(actual_coords))
