extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -600.0


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("track_up") and not is_on_ceiling():
		position.y -= 100
	if Input.is_action_just_pressed("track_down") and not is_on_floor():
		position.y += 100
	
	move_and_slide()
