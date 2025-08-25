extends CharacterBody2D

@export var speed: float = 1000.0
@export var rotation_offset: float = deg_to_rad(-90)
@export var rotation_speed: float = 10.0
@export var friction: float = 5.0  # plus haut = plus rapide à ralentir

var direction := Vector2.ZERO
var target_position: Vector2 = Vector2.ZERO
var moving_to_click := false
var following_cursor := false

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				following_cursor = true
				target_position = event.position
			else:
				following_cursor = false
				moving_to_click = true

func _physics_process(delta: float) -> void:
	# Détermination de la direction désirée
	var desired_direction := Vector2.ZERO
	
	if following_cursor:
		target_position = get_global_mouse_position()
		var to_target = target_position - global_position
		if to_target.length() > 40:
			desired_direction = to_target.normalized()
	elif moving_to_click:
		var to_target = target_position - global_position
		if to_target.length() > 50:
			desired_direction = to_target.normalized()
		else:
			moving_to_click = false
	else:
		desired_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	# Interpolation pour un mouvement glissant
	direction = direction.lerp(desired_direction, friction * delta)

	# Déplacement
	velocity = direction * speed
	move_and_slide()

	# Rotation lissée
	if direction.length() > 0.01:
		var target_angle = direction.angle() + rotation_offset
		rotation = lerp_angle(rotation, target_angle, rotation_speed * delta)

	# Animation
	if velocity.length() > 5:
		$AnimatedSprite2D.play("walking")
	else:
		$AnimatedSprite2D.play("idle")
