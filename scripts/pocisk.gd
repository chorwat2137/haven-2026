extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x -= get_parent().speed / 2
	
func _on_Bullet_body_entered(body):
	print("coliision")
	if body.is_in_group("mobs"):
		body.queue_free()
	queue_free()
