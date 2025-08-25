extends CharacterBody2D

@export var speed: float = 400.0
@export var rotation_offset: float = deg_to_rad(-90)  # corrige selon l'orientation du sprite
@export var rotation_speed: float = 15.0              # plus haut = plus réactif

var direction := Vector2.ZERO
var moving_to_click := false

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			moving_to_click = event.pressed  # true quand on appuie, false quand on relâche

func _physics_process(delta: float) -> void:
	if moving_to_click:
		# Toujours viser la position actuelle de la souris
		var mouse_pos := get_global_mouse_position()
		var to_target := mouse_pos - global_position
		if to_target.length() > 5:
			direction = to_target.normalized()
		else:
			direction = Vector2.ZERO
	else:
		# Sinon clavier
		direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	# Déplacement
	velocity = direction * speed
	move_and_slide()

	# Rotation lissée
	if direction != Vector2.ZERO:
		var target_angle = direction.angle() + rotation_offset
		rotation = lerp_angle(rotation, target_angle, rotation_speed * delta)

	# Animations
	if velocity.length() > 0.1:
		$AnimatedSprite2D.play("walking")
	else:
		$AnimatedSprite2D.play("idle")
