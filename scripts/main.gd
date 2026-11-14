
extends Node

@onready var music = $AudioStreamPlayer

var triola_scene = preload("res://scenes/triola.tscn")
var pocisk_scene = preload("res://scenes/pocisk.tscn")

var lane_positions: Array[float] = []
var obstacle_types = [triola_scene, pocisk_scene]
var obstacles: Array = []

var speed: float
const START_SPEED: float = 5.0
const MAX_SPEED: float = 25.0

var screen_size: Vector2i
var score: float = 0.0
var last_obs

var min_distance: float = 2000.0
var is_rewinding: bool = false


func _ready() -> void:
	speed = START_SPEED

	screen_size = get_viewport().get_visible_rect().size

	$Player/Camera2D2/Spectrum.position.y = -screen_size.y / 2.0

	var center_y = screen_size.y / 2.0

	lane_positions = [
		center_y - 200,
		center_y,
		center_y + 200
	]


func _process(delta: float) -> void:

	score += speed * delta * 60.0

	# Move player/world
	$Player.position.x += speed * delta * 60.0

	$Linia.position.x = $Player.position.x - screen_size.x

	if not is_rewinding:
		generate_obs()


func generate_obs() -> void:

	if obstacles.is_empty() or last_obs.position.x < score + min_distance:

		var obs_type = obstacle_types.pick_random()

		var obs_count = randi_range(1, 2)

		var available_lanes = [0, 1, 2]
		available_lanes.shuffle()

		for i in range(obs_count):

			var obs = obs_type.instantiate()

			var obs_x: float = screen_size.x + score + 100
			var obs_y: float = lane_positions[available_lanes[i]]

			last_obs = obs
			add_obs(obs, obs_x, obs_y)


func add_obs(obs, x, y) -> void:

	obs.position = Vector2(x, y)
	obs.body_entered.connect(hit_obs)

	add_child(obs)
	obstacles.append(obs)


func hit_obs(body) -> void:

	if body.name == "Player":
		collision_handle()


func collision_handle() -> void:

	if is_rewinding:
		return

	is_rewinding = true

	music.start_rewind()

	speed = -START_SPEED

	await get_tree().create_timer(2.0).timeout

	music.stop_rewind()

	speed = START_SPEED
	is_rewinding = false
