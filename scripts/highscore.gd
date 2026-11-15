extends Node
var highscore = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var root = get_tree().root
	# Using a negative index counts from the end, so this gets the last child node of `root`.
	current_scene = root.get_child(-1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
