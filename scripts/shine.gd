extends Sprite2D

@export var rotation_speed: float = 2.0
@export var animation_duration: float = 0.3

var tween: Tween

func _ready():
	scale = Vector2.ZERO
	show_sprite()

func _process(delta: float) -> void:
	rotation += rotation_speed * delta

func show_sprite():
	visible = true
	scale = Vector2.ZERO

	tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE, animation_duration) \
		.set_trans(Tween.TRANS_BACK) \
		.set_ease(Tween.EASE_OUT)

func hide_sprite():
	tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, animation_duration) \
		.set_trans(Tween.TRANS_BACK) \
		.set_ease(Tween.EASE_IN)

	tween.tween_callback(func(): visible = false)
