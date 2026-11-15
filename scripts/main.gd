extends Node

@onready var music = get_node("AudioStreamPlayer")

var triola_scene = preload("res://scenes/triola.tscn")
var pocisk_scene = preload("res://scenes/pocisk.tscn")
var sp1_scene = preload("res://scenes/sp1.tscn")
var sp2_scene = preload("res://scenes/sp2.tscn")
var sp3_scene = preload("res://scenes/sp3.tscn")
var sp4_scene = preload("res://scenes/sp4.tscn")
var sp5_scene = preload("res://scenes/sp5.tscn")
var sp6_scene = preload("res://scenes/sp6.tscn")
var sp7_scene = preload("res://scenes/sp7.tscn")
var sp8_scene = preload("res://scenes/sp8.tscn")
var hp = preload("res://scenes/hp.tscn")

var lane_positions: Array[float] = []
var obstacle_types := [triola_scene, pocisk_scene, sp1_scene, sp2_scene, sp3_scene, sp4_scene, sp5_scene, sp6_scene, sp7_scene, sp8_scene]
var obstacles: Array = []
var obstacle_heights = [200, 0, -200]

var invincible = false
var is_rewinding: bool = false
var game_over = false

var hp_on_screen: Array = []

var rewind_duration = 120
var current_rewind = 121

var speed: float
const START_SPEED: float = 10.0
const MAX_SPEED: float = 25.0
var cur_speed: float = START_SPEED

var screen_size: Vector2i
var score = 0
var high_score = 0
var last_obs

var min_distance = 1000


func _ready() -> void:
	add_hearts()

	speed = START_SPEED
	screen_size = get_viewport().get_visible_rect().size

	$Player/Camera2D2/Spectrum.position.y = float(-screen_size.y) / 2

	var center_y = screen_size.y / 2.0

	lane_positions = [
		center_y - 200,
		center_y,
		center_y + 200
	]


func _process(delta: float) -> void:
	if game_over:
		return

	if speed < MAX_SPEED and not is_rewinding:
		speed += 0.05

	score += speed
	show_score()
	
	$Player.position.x += speed * delta * 60

	$Linia.position.x = $Player.position.x - float(screen_size.x) / 2

	for heart in hp_on_screen:
		if is_instance_valid(heart):
			heart.position.x += speed * delta * 60
			heart.position.y = $Player.position.y - 400

	generate_obs()

func show_score():
	if score > high_score:
		high_score = score
	$HUD.get_node("HighScoreLabel").text = "HIGH SCORE: " + str(int(high_score/100))
	$HUD.get_node("ScoreLabel").text = "SCORE: " + str(int(score/100))

func add_hearts():
	for i in range(3):
		var h = hp.instantiate()
		h.global_position = Vector2(
			$heart_spawner.position.x + 100 * i,
			$heart_spawner.position.y
		)

		add_child(h)
		hp_on_screen.append(h)
		print("dodano hp")


func generate_obs():
	if obstacles.is_empty() or last_obs == null or last_obs.position.x < score + min_distance:

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
	obs.position = Vector2(x, y)
	obs.add_to_group("obsticles")
	obs.body_entered.connect(hit_obs)

	add_child(obs)
	obstacles.append(obs)


func hit_obs(body):
	if body.name == "Player" and invincible == false:
		body.hp -= 1
		if hp_on_screen[body.hp]:
			hp_on_screen[body.hp].queue_free()

	if body.hp <= 0:
		game_over = true
		#get_tree().paused = true
		get_tree().change_scene_to_file.call_deferred("res://scenes/restart.tscn")
		return

	collision_handle()


func invincibility():
	if invincible == true:
		return
	$Player/Shine.show_sprite()
	invincible = true

	await get_tree().create_timer(2.0).timeouts

	if not is_inside_tree():
		return

	invincible = false
	$Player/Shine.visible = false
	await get_tree().create_timer(1.5).timeout
	invincible = false
	$Player/Shine.hide_sprite()

func collision_handle() -> void:
	if is_rewinding or game_over:
		return

	is_rewinding = true
	invincible = true

	$Player/Sprite2D.texture = load("res://gfx/player_back.png")

	music.start_rewind()

	speed = -abs(START_SPEED * 2)

	invincibility()

	await get_tree().create_timer(1.0).timeout

	if not is_inside_tree():
		return

	music.stop_rewind()

	speed = START_SPEED

	$Player/Sprite2D.texture = load("res://gfx/player_forward.png")

	is_rewinding = false
