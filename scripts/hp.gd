extends Node2D


func die():
	$Area2D/Sprite2D.visible = false
	$Area2D/AnimatedSprite2D.visible = true
	$Area2D/AnimatedSprite2D.play("death")
	
