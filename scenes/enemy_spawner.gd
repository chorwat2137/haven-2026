extends Node

var timer : Timer

var enemy = preload("res://scenes/enemy.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer = Timer.new()
	add_child(timer)
	
	timer.wait_time = 1.0
	timer.one_shot = false
	timer.timeout.connect(_on_timer_timeout)
	timer.start()
	


func _on_timer_timeout() -> void:
	var e = enemy.instantiate()
	add_sibling(e)
	e.global_transform = $ghost_marker.global_transform
