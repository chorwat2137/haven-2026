extends CharacterBody2D

@export var lane_distance: float = 200.0
@export var movement_speed: float = 10.0

var current_lane: int = 1 # 0 = left, 1 = middle, 2 = right

func _process(delta: float) -> void:
	# Read keyboard input
	if Input.is_action_just_pressed("ui_up"):
		current_lane = max(0, current_lane - 1)

	if Input.is_action_just_pressed("ui_down"):
		current_lane = min(2, current_lane + 1)

	# Calculate target X position
	var target_x = (current_lane - 1) * lane_distance

	# Smoothly move player
	position.x = lerp(
		position.x,
		target_x,
		1.0 - exp(-movement_speed * delta)
	)
