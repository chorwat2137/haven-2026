extends CharacterBody2D

var pause = false
var lane_positions: Array[float] = []
var bullet = preload("res://scenes/mojpocisk.tscn")
@export var movement_speed: float = 10.0
@export var hp: int = 3
var current_lane: int = 1 # 0 = top, 1 = middle, 2 = bottom
var center_y: float
var can_shoot: bool = true
var shoot_timer = Timer.new()
var shoot_delay: float = 1.0

func shoot():
	if can_shoot:
		var b = bullet.instantiate()
		var b_y = self.position.y
		var b_x = self.position.x
		b.position = Vector2i(b_x, b_y)
		get_parent().add_child(b)
		add_child(shoot_timer)
		shoot_timer.start()
		can_shoot = false

func reload():
	can_shoot = true
	#shoot_timer.queue_free()
func _ready() -> void:
	# Get vertical center of the screen
	center_y = get_viewport_rect().size.y / 2.0
	shoot_timer.wait_time = shoot_delay
	shoot_timer.timeout.connect(reload)
	# Define the three lanes
	lane_positions = [
		center_y - 200,
		center_y,
		center_y + 200
	]

	# Start in the middle lane
	position.y = lane_positions[current_lane]


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
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
