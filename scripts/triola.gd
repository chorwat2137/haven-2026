extends Area2D

var rng = RandomNumberGenerator.new()
var timer_disappear = Timer.new() 

func _ready() -> void:
	var random = rng.randi_range(1, 8)
	print(random)
	timer_disappear.wait_time = 0.05
	timer_disappear.timeout.connect(make_inivisible)
	add_child(timer_disappear)

	var file = "res://gfx/enemy/%d.png" % random
	$Sprite2D.texture = load(file)
	
func die():
	timer_disappear.start()
	$Sprite2D.visible = false
	$AnimatedSprite2D.visible = true
	$AnimatedSprite2D.play("death")

func make_inivisible():
	$AnimatedSprite2D.visible = false
	self.queue_free()

func _process(_delta: float) -> void:
	pass
