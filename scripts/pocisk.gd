extends Area2D

var timer_disappear = Timer.new() 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer_disappear.wait_time = 0.2
	timer_disappear.timeout.connect(make_inivisible)
	add_child(timer_disappear)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	position.x -= get_parent().speed / 4	
	
func die():
	timer_disappear.start()
	$Sprite2D.visible = false
	$AnimatedSprite2D.visible = true
	$AnimatedSprite2D.play("death")

func make_inivisible():
	$AnimatedSprite2D.visible = false
	self.queue_free()
	
