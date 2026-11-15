extends Sprite2D

@export var rotation_speed: float = 2.0
@export var animation_duration: float = 0.3
@export var target_scale: Vector2 = Vector2(0.4, 0.4)

var tween: Tween

func _ready():
	visible = false
	scale = Vector2.ZERO

func _process(delta: float) -> void:
	rotation += rotation_speed * delta

func show_sprite():
	if tween and tween.is_running():
		tween.kill()

	visible = true

	tween = create_tween()
	tween.tween_property(self, "scale", target_scale, animation_duration)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)

func hide_sprite():
	if not visible:
		return

	if tween and tween.is_running():
		tween.kill()

	tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, animation_duration)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_IN)

	tween.tween_callback(func():
		visible = false
	)
