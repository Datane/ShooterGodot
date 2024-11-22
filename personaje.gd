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

# Variable para almacenar la posición del JUGADOR
var player_position = Vector3.ZERO

######### VARIABLES PARA CARGA DEL MAPA ###########
@export var load_distance: float = 50.0  # Distancia de carga del mapa
@export var unload_distance: float = 55.0  # Distancia de descarga del mapa
var loaded_nodes: Array = []  # Nodo cargado en memoria
var map_nodes: Array = []     # Nodo que está en el mapa

############### Variables de optimización gráfica ##############
@export var max_nodes_in_memory: int = 30  # Número máximo de nodos que se pueden cargar en memoria al mismo tiempo

###############

# Inicialización FUNCION PRINCIPAL 
func _ready():
	camera = get_node("Camera3D")  # Ajusta la ruta si es necesario
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	print("El script ha comenzado. Monitoreando la posición del jugador en 3D.")

	# Recopilar nodos del mapa
	var map_root = get_node_or_null("Map")  # Usa get_node_or_null para evitar errores
	if map_root:
		collect_map_nodes(map_root)
	else:
		print("Error: Nodo 'Map' no encontrado.")

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
		rotation_y -= event.relative.x * h_sensibilidad
		rotation_x = clamp(rotation_x - event.relative.y * v_sensibilidad, -89.0, 89.0)
		
		rotation_degrees.y = rotation_y
		camera.rotation_degrees.x = rotation_x

# Manejar la captura/liberación del cursor
func _process(_delta):
	handle_mouse_mode_toggle()

	# Actualiza la posición del jugador cada frame
	player_position = global_transform.origin
	print("Posición del jugador: ", player_position)

	# Llamar a la gestión de carga del mapa
	handle_map_loading()

# Función para alternar el modo del mouse (capturado o visible)
func handle_mouse_mode_toggle():
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

################ CARGA DEL MAPA FUNCIONES #################

# Recopilar nodos del mapa dinámicamente
func collect_map_nodes(root: Node):
	if root == null:
		print("Error: el nodo raíz es nulo")
		return  # No continuar si el nodo es nulo

	for node in root.get_children():
		if node is Node3D and node.name != "Player":  # Excluir al jugador
			map_nodes.append(node)
			print("Nodo agregado:", node.name)  # Imprimir nombre del nodo para verificar
		if node.get_child_count() > 0:
			collect_map_nodes(node)

# Administrar carga dinámica del mapa
func handle_map_loading():
	var nodes_to_load = []  # Nodos a cargar durante este fotograma

	# Recorremos todos los nodos en el mapa
	for node in map_nodes:
		if node and node is Node3D:
			var distance = player_position.distance_to(node.global_transform.origin)

			# Sólo procesar si el nodo está cerca del jugador
			if distance < unload_distance and !node.visible:
				nodes_to_load.append(node)

	# Cargar nodos cercanos al jugador, limitados por el número máximo permitido
	for node in nodes_to_load:
		if node not in loaded_nodes and len(loaded_nodes) < max_nodes_in_memory:
			node.visible = true
			node.set_process(true)  # Activar procesamiento de nodos solo cuando están visibles
			loaded_nodes.append(node)
			print("Nodo cargado:", node.name)

	# Descargar nodos lejanos que ya no están cerca del jugador
	var nodes_to_unload = []
	for node in loaded_nodes:
		var distance = player_position.distance_to(node.global_transform.origin)
		if distance > unload_distance:
			nodes_to_unload.append(node)

	for node in nodes_to_unload:
		if node in loaded_nodes:
			node.visible = false
			node.set_process(false)  # Desactivar el procesamiento de nodos cuando no son visibles
			loaded_nodes.erase(node)
			print("Nodo descargado:", node.name)

