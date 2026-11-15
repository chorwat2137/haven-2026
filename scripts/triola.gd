extends Area2D

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	var random = rng.randi_range(1, 8)
	print(random)

	var file = "res://gfx/enemy/%d.png" % random
	$Sprite2D.texture = load(file)

func _process(_delta: float) -> void:
	pass
