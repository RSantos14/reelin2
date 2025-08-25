extends CharacterBody2D

#@export var speed: float = 1.0   # maximum speed (used for animation scaling if needed)
#@export var step_distance: float = 0.09  # pixels moved per frame
var direction := Vector2.ZERO

func _physics_process(delta: float) -> void:
	# Get input
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * 400
	move_and_slide()
	# Move parent node in small steps
	#if direction != Vector2.ZERO:
		# Normalize direction for consistent diagonal movement
	#	var move_vector = direction.normalized() * step_distance
	#	position += move_vector  # manually move in small steps

	# Rotate child sprite to match movement
	#if direction != Vector2.ZERO:
	#	var angle = direction.angle()
	#	# Snap to nearest 45° and add sprite offset
	#	$AnimatedSprite2D.rotation = round(angle / (PI/4)) * (PI/4) + deg_to_rad(90)

	# Handle animations
	if direction == Vector2.ZERO:
		$AnimatedSprite2D.play("idle")
	else:
		$AnimatedSprite2D.play("walking")
