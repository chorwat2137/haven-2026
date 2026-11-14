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
		$Spectrum.position.x = $Player.position.x - screen_size.x /2
	$Linia.position.x = $Player.position.x - screen_size.x/2
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
	
	score += speed
	$Player.position.x += speed * delta * 60
	$Spectrum.position.x = $Player.position.x - screen_size.x /2
	$Linia.position.x = $Player.position.x - screen_size.x/2
	$Spectrum.position.y = $Player.position.y - screen_size.y /2
	generate_obs()

var min_distance = 300


func generate_obs():
	if obstacles.is_empty() or last_obs.position.x < score + min_distance:

		var obs_type = obstacle_types[randi() % obstacle_types.size()]

		var max_obs = 2
		var obs_count = randi_range(1, max_obs)

		var available_lanes = [0, 1, 2]
		available_lanes.shuffle()

		for i in range(obs_count):
			var obs = obs_type.instantiate()

			var obs_x: float = screen_size.x + score + 100
			var obs_y: float = lane_positions[available_lanes[i]]

			last_obs = obs
			add_obs(obs, obs_x, obs_y)


func add_obs(obs, x, y):
	obs.position = Vector2i(x, y)
	add_child(obs)
	obstacles.append(obs)
