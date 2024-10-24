extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Obtener la gravedad del proyecto
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Variables de rotación y referencia de cámara
var camera
var rotation_x = 0.0
var rotation_y = 0.0
var h_sensibilidad = 0.1  # Sensibilidad horizontal del mouse
var v_sensibilidad = 0.1   # Sensibilidad vertical del mouse

# Inicialización
func _ready():
	camera = get_node("Camera3D")  # Ajusta la ruta si es necesario
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Rotación del mouse
func _input(event):
	handle_mouse_input(event)

# Función de física (movimiento y salto)
func _physics_process(delta):
	# Añadir gravedad si no está en el suelo
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Manejar el salto
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Dirección del movimiento
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

# Manejar la rotación con el mouse
func handle_mouse_input(event):
	if event is InputEventMouseMotion:
		# Rotación de la cámara con el movimiento del ratón
		rotation_y -= event.relative.x * h_sensibilidad
		rotation_x = clamp(rotation_x - event.relative.y * v_sensibilidad, -89.0, 89.0)
		
		# Aplicar la rotación al personaje y la cámara
		rotation_degrees.y = rotation_y
		camera.rotation_degrees.x = rotation_x

# Manejar la captura/liberación del cursor
func _process(delta):
	handle_mouse_mode_toggle()

# Función para alternar el modo del mouse (capturado o visible)
func handle_mouse_mode_toggle():
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
