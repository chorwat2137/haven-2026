extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -600.0

var bullet = preload("res://scenes/bullet.tscn")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		shoot()

func shoot():
	var b = bullet.instantiate()
	self.owner.add_child(b)
	b.global_transform = $player_bullet_marker.global_transform
	print("shoot")

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("track_up") and not is_on_ceiling():
		position.y -= 100
	if Input.is_action_just_pressed("track_down") and not is_on_floor():
		position.y += 100
<<<<<<< HEAD

=======
	
>>>>>>> 1c0d654eee313b6a9d95523474a7549ffc0b113f
	move_and_slide()
"res://scenes/bullet.tscn"
