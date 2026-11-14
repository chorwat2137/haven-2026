extends Node

var triola_scene = preload("res://scenes/triola.tscn")

var obstacle_types := [triola_scene]
var obstacles : Array
var obstacle_heights = [200, 0, -200]


var speed: float
const START_SPEED: float = 5.0
const MAX_SPEED: int = 25
var screen_size: Vector2i
var score = 0
var last_obs
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
	generate_obs()
	
func generate_obs():
	if obstacles.is_empty() or last_obs.position.x < score + randi_range(300, 500):
		var obs_type = obstacle_types[randi() % obstacle_types.size()]
		var obs
		obs = obs_type.instantiate()
		var obs_height = obs.get_node("Sprite2D").texture.get_height()
		var obs_scale = obs.get_node("Sprite2D").scale
		var obs_x: int = screen_size.x + score + 100
		var obs_y: int = screen_size.y / 2.0 + obstacle_heights[randi() % obstacle_heights.size()]
		last_obs = obs
		add_obs(obs, obs_x, obs_y)


func add_obs(obs, x, y):
	obs.position = Vector2i(x, y)
	add_child(obs)
	obstacles.append(obs)
