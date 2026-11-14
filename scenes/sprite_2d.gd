extends Sprite2D

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	var random = rng.randi_range(1, 8)
	print(random)

	var file = "res://gfx/enemy/%d.png" % random
	texture = load(file)

func _process(delta: float) -> void:
	pass
