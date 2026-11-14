extends CharacterBody2D

@export var lane_distance: float = 200.0
@export var movement_speed: float = 10.0

var current_lane: int = 1 # 0 = top, 1 = middle, 2 = bottom
var center_y: float

func _ready() -> void:
	# Get vertical center of the screen
	center_y = get_viewport_rect().size.y / 2.0

	# Start in the middle of the screen
	position.y = center_y


func _process(delta: float) -> void:

	if Input.is_action_just_pressed("ui_up"):
		current_lane = max(0, current_lane - 1)

	if Input.is_action_just_pressed("ui_down"):
		current_lane = min(2, current_lane + 1)

	# Calculate target position
	var target_y = center_y + (current_lane - 1) * lane_distance

	# Smooth movement
	position.y = lerp(
		position.y,
		target_y,
		1.0 - exp(-movement_speed * delta)
	)
