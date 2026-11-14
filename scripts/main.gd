extends Node

var triola_scene = preload("res://scenes/triola.tscn")


var speed: float
const START_SPEED: float = 10.0
const MAX_SPEED: int = 25
var screen_size: Vector2i
var score = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_window().size
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	speed = START_SPEED
	score += speed
	$Player.position.x += speed
	print(score)
