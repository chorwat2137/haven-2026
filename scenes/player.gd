extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -600.0

func _physics_process(delta: float) -> void:
<<<<<<< HEAD
	if Input.is_action_just_pressed("track_up") and not is_on_ceiling():
		position.y -= 100
	if Input.is_action_just_pressed("track_down") and not is_on_floor():
		position.y += 100
	
=======
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

>>>>>>> 4daea22e4581cb001e2d9c289d14824555a8eec7
	move_and_slide()
