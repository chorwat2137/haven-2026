extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.body_entered.connect(delete_proj)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x -= get_parent().speed / 2	
	
func delete_proj(body):
	if body.name:
		body.queue_free()
	queue_free()
