extends Area2D

@export var speed: float = 800.0

func _ready():
	body_entered.connect(_on_body_entered)

func _physics_process(delta):
	position.x += speed * delta

func _on_body_entered(body):
	if body.is_in_group("obstacle"):
		body.queue_free()
		queue_free()
