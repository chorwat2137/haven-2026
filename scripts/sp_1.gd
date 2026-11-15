extends Area2D

var timer_disappear = Timer.new() 

func _ready() -> void:
	timer_disappear.wait_time = 0.5
	timer_disappear.timeout.connect(make_inivisible)
	add_child(timer_disappear)


func die():
	timer_disappear.start()
	$Sprite2D.visible = false
	$AnimatedSprite2D.visible = true
	$AnimatedSprite2D.play("death")

func make_inivisible():
	$AnimatedSprite2D.visible = false
	self.queue_free()
