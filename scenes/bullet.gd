extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var direction = 1

func _process(delta: float) -> void:
	if position.x >= 300:
		print("delete")
		queue_free()

func _physics_process(delta: float) -> void:
	velocity.x = SPEED * delta * 100
	move_and_slide()
