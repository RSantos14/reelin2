extends CharacterBody2D

@export var speed: float = 400.0
@export var rotation_offset: float = deg_to_rad(-90)
@export var rotation_speed: float = 15.0

var direction := Vector2.ZERO
var target_position: Vector2 = Vector2.ZERO
var moving_to_click := false
var following_cursor := false

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# Commence à suivre le curseur
				following_cursor = true
				target_position = event.position
			else:
				# Relâché : stoppe le suivi, mais continue vers la dernière position
				following_cursor = false
				moving_to_click = true

func _physics_process(delta: float) -> void:
	# Détermination de la direction
	if following_cursor:
		# Suivre la position du curseur tant que le clic est maintenu
		target_position = get_global_mouse_position()
		var to_target = target_position - global_position
		if to_target.length() > 5:
			direction = to_target.normalized()
		else:
			direction = Vector2.ZERO
	else:
		# Déplacement vers le dernier click
		if moving_to_click:
			var to_target = target_position - global_position
			if to_target.length() > 5:
				direction = to_target.normalized()
			else:
				direction = Vector2.ZERO
				moving_to_click = false
		else:
			# Contrôle clavier
			direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	# Déplacement
	velocity = direction * speed
	move_and_slide()

	# Rotation lissée
	if direction != Vector2.ZERO:
		var target_angle = direction.angle() + rotation_offset
		rotation = lerp_angle(rotation, target_angle, rotation_speed * delta)

	# Animation
	if velocity.length() > 0.1:
		$AnimatedSprite2D.play("walking")
	else:
		$AnimatedSprite2D.play("idle")
