extends Area2D

@export var speed: float = 800.0

var screen_size: Vector2i
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.area_entered.connect(handle_delete)

func _physics_process(delta):
	position.x += speed * delta
	screen_size = get_viewport().get_visible_rect().size

func _on_body_entered(body):
	if body.is_in_group("obstacle"):
		body.queue_free()
		queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	position.x += get_parent().speed * 1.5
	if position.x  < get_parent().get_node("Player").position.x:
		print("zmywam się stąd")
		self.queue_free()
	
func handle_delete(area):
	print("kolizja")
	area.queue_free()
	self.queue_free()
