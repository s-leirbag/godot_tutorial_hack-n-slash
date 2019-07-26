extends TileMap

func _ready():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	for x in range(-20, -11):
		set_cell(x, 6, rng.randi_range(-1, 2))
	
	for x in range(51, 60):
		set_cell(x, 6, rng.randi_range(-1 ,2))