extends Area2D
var screen_size: Vector2i
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.area_entered.connect(handle_delete)

	screen_size = get_viewport().get_visible_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += get_parent().speed * 2
	if position.x < get_parent().get_node("Player").position.x or position.x > get_parent().get_node("Player").position.x + screen_size.x:
		self.queue_free()
	
func handle_delete(area):
	print("kolizja")
	area.queue_free()
	self.queue_free()
