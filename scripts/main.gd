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
var obstacle_types := [triola_scene, pocisk_scene, sp1_scene, sp2_scene, sp3_scene, sp4_scene, sp5_scene, sp6_scene, sp7_scene, sp8_scene,]
var obstacles : Array
var obstacle_heights = [200, 0, -200]
var invincible = false
var is_rewinding: bool = false

var hp_on_screen : Array

var rewind_duration = 120
var current_rewind = 121

var speed: float
const START_SPEED: float = 10.0
const MAX_SPEED: float = 25.0
var cur_speed: float = START_SPEED
var screen_size: Vector2i
var score = 0
var last_obs

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_hearts()	
	
	
	speed = START_SPEED
	screen_size = get_viewport().get_visible_rect().size
	$Player/Camera2D2/Spectrum.position.y = 0 - screen_size.y /2
	var center_y = screen_size.y / 2.0

	lane_positions = [
		center_y - 200,
		center_y,
		center_y + 200
	]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if speed < MAX_SPEED and is_rewinding == false:
		speed += 0.05
	score += speed
	$Player.position.x += speed * delta * 60
	#$Spectrum.position.x = $Player.position.x - screen_size.x /2

	$Linia.position.x = $Player.position.x - screen_size.x
	if hp_on_screen[0]:
		hp_on_screen[0].position.x += speed * delta * 60
		hp_on_screen[0].position.y = $Player.position.y - 400
	if hp_on_screen[1]:
		hp_on_screen[1].position.x += speed * delta * 60
		hp_on_screen[1].position.y = $Player.position.y - 400
	if hp_on_screen[2]:
		hp_on_screen[2].position.x += speed * delta * 60
		hp_on_screen[2].position.y = $Player.position.y - 400

	$Linia.position.x = $Player.position.x - screen_size.x / 2

	#$Spectrum.position.y = $Player.position.y - screen_size.y /2
	generate_obs()

var min_distance = 1000

func add_hearts():
	for i in range(3):
		var h = hp.instantiate()
		h.global_position = Vector2($heart_spawner.position.x + 100*i, $heart_spawner.position.y)
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
	obs.position = Vector2i(x, y)
	obs.add_to_group("obsticles")
	obs.body_entered.connect(hit_obs)

	add_child(obs)
	obstacles.append(obs)

func hit_obs(body):
	if body.name == "Player":
		body.hp -= 1
		if hp_on_screen[body.hp]:
			hp_on_screen[body.hp].queue_free()
		if body.hp <= 0:
			get_tree().paused = true
		collision_handle()
		

#func del_bullets(body):
	#if body.name == "Player" && bo m    0dy.position.x < 
	

		

func invincibility():
	invincible = true
	await get_tree().create_timer(2.0).timeout
	invincible = false
func collision_handle() -> void:

	if is_rewinding:
		return

	is_rewinding = true
	$Player/Sprite2D.texture = load("res://gfx/player_back.png")
	music.start_rewind()

	speed = -abs(START_SPEED*2)
	invincibility()
	await get_tree().create_timer(1.0).timeout

	music.stop_rewind()

	speed = START_SPEED
	$Player/Sprite2D.texture = load("res://gfx/player_forward.png")
	is_rewinding = false
