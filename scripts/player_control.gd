extends CharacterBody2D

var lane_positions: Array[float] = []
@export var movement_speed: float = 10.0

var current_lane: int = 1 # 0 = top, 1 = middle, 2 = bottom
var center_y: float

func _ready() -> void:
	# Get vertical center of the screen
	center_y = get_viewport_rect().size.y / 2.0

	lane_positions = [
		center_y - 200,
		center_y,
		center_y + 200
	]

	position.y = lane_positions[current_lane]


func _process(delta: float) -> void:

	if Input.is_action_just_pressed("ui_up"):
		current_lane = max(0, current_lane - 1)

	if Input.is_action_just_pressed("ui_down"):
		current_lane = min(2, current_lane + 1)

	# Calculate target position
	var target_y = 

	# Smooth movement
	position.y = lerp(
		position.y,
		target_y,
		1.0 - exp(-movement_speed * delta)
	)
