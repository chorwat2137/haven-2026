extends Node

var triola_scene = preload("res://scenes/triola.tscn")
var pocisk_scene = preload("res://scenes/pocisk.tscn")
var lane_positions: Array[float] = []
var obstacle_types := [triola_scene, pocisk_scene]
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
	screen_size = get_viewport().get_visible_rect().size

	var center_y = screen_size.y / 2.0

	lane_positions = [
		center_y - 200,
		center_y,
		center_y + 200
	]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	speed = START_SPEED
	
	score += speed * delta * 60
	$Player.position.x += speed * delta * 60
	$Spectrum.position.x = $Player.position.x - screen_size.x /2
	$Spectrum.position.y = $Player.position.y - screen_size.y /2
	generate_obs()
	
func generate_obs():
	if obstacles.is_empty() or last_obs.position.x < score + randi_range(300, 500):
		var obs_type = obstacle_types[randi() % obstacle_types.size()]
		var obs
		var max_obs = 2
		for i in range(randi() % max_obs + 1):
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
