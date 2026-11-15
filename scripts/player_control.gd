extends CharacterBody2D

var pause = false
var lane_positions: Array[float] = []
var bullet = preload("res://scenes/mojpocisk.tscn")
@export var movement_speed: float = 30.0
@export var hp: int = 3
var current_lane: int = 1 # 0 = top, 1 = middle, 2 = bottom
var center_y: float
var can_shoot: bool = true
var shoot_timer = Timer.new()
@export var shoot_delay: float = 0.5
var hp_t = preload("res://scenes/hp.tscn")
var hp_on_screen: Array = []
var score = 0

func shoot():
	if can_shoot:
		var b = bullet.instantiate()
		var b_y = lane_positions[current_lane]
		var b_x = self.position.x
		b.position = Vector2(b_x, b_y)
		get_parent().add_child(b)

		shoot_timer.start()
		can_shoot = false

func reload():
	can_shoot = true
	#shoot_timer.queue_free()
func _ready() -> void:
	center_y = get_viewport_rect().size.y / 2.0

	shoot_timer.wait_time = shoot_delay
	shoot_timer.one_shot = true
	shoot_timer.timeout.connect(reload)

	add_child(shoot_timer)

	lane_positions = [
		center_y - 200,
		center_y,
		center_y + 200
	]

	position.y = lane_positions[current_lane]
	add_hearts()


func add_hearts():
	for i in range(hp):
		var h = hp_t.instantiate()
		h.global_position = Vector2(
			$heart_spawner.position.x + 100 * i,
			$heart_spawner.position.y
		)
		add_child(h)
		hp_on_screen.append(h)
		
func hp_dead(index):
	hp_on_screen[index].die()

func _process(delta: float) -> void:
	show_score()
	if Input.is_action_just_pressed("shoot") and pause == false:
		shoot()
	# Keyboard input
	if Input.is_action_just_pressed("track_up"):
		current_lane = max(0, current_lane - 1)

	if Input.is_action_just_pressed("track_down"):
		current_lane = min(2, current_lane + 1)
	if Input.is_action_just_pressed("pause"):
		
		pause = !pause
		get_tree().paused = pause
		
		if pause:
			$Sprite2D.texture = load("res://gfx/player_stop.png")
			score -= 10
		else:
			$Sprite2D.texture = load("res://gfx/player_forward.png")

	# Get target Y position
	var target_y: float = lane_positions[current_lane]

	# Smooth movement
	position.y = lerp(
		position.y,
		target_y,
		1.0 - exp(-movement_speed * delta)
	)
func show_score():
	if score > Highscore.highscore:
		Highscore.highscore = score
		Highscore.save_game()
	get_parent().$HUD.get_node("HighScoreLabel").text = "HIGH SCORE: " + str(int(Highscore.highscore/100))
	get_parent().$HUD.get_node("ScoreLabel").text = "SCORE: " + str(int(get_parent().score/100))
	get_parent().$HUD.get_node("SpeedLabel").text = "SPEED: " + str(int(get_parent().speed))
