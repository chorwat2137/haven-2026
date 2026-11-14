extends Sprite2D

var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var random = randi() % 8 + 1
	print(random)
	var directory = DirAccess.open("../gfx/enemy")


		
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x -= 0.5
