extends Area2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var direction = 1

func _process(delta: float) -> void:
	if position.x >= 500:
		queue_free()

func _physics_process(delta: float) -> void:
	position.x += SPEED * delta

func _on_Bullet_body_entered(body):
	if body.is_in_group("mobs"):
		body.queue_free()
	queue_free()
