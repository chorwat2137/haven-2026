extends Node2D

var timer_disappear = Timer.new() 

func _ready() -> void:
	timer_disappear.wait_time = 0.5
	timer_disappear.timeout.connect(make_inivisible)
	add_child(timer_disappear)


func die():
	timer_disappear.start()
	$Area2D/Sprite2D.visible = false
	$Area2D/AnimatedSprite2D.visible = true
	$Area2D/AnimatedSprite2D.play("death")

func make_inivisible():
	$Area2D/AnimatedSprite2D.visible = false
	self.queue_free()
