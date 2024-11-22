extends CharacterBody3D

# Constantes y configuración
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const H_SENSITIVITY = 0.1  # Sensibilidad horizontal del mouse
const V_SENSITIVITY = 0.1  # Sensibilidad vertical del mouse

# Variables globales
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")  # Gravedad
@export var load_distance: float = 25.0  # Distancia de carga del mapa
@export var unload_distance: float = 25.0  # Distancia de descarga del mapa

# Referencias
var camera: Camera3D
var raycast: RayCast3D
var original_material: Material

# Variables de estado
var rotation_x = 0.0
var rotation_y = 0.0
var loaded_nodes: Array = []
var map_nodes: Array = []

# Inicialización
func _ready():
	# Configurar referencias
	camera = $Camera3D
	raycast = $RayCast3D
	raycast.enabled = true
	
	# Configurar el modo del mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# Recopilar nodos del mapa
	collect_map_nodes(get_tree().root)

# Entrada del ratón
func _input(event):
	if event is InputEventMouseMotion:
		handle_mouse_motion(event)

# Lógica de física (movimiento, salto y lógica del mapa)
func _physics_process(delta):
	handle_gravity(delta)
	handle_movement(delta)
	handle_map_loading()
	handle_ray_detection()
"""
# Actualizar la rotación de la cámara
func handle_mouse_motion(event: InputEventMouseMotion):
	rotation_y -= event.relative.x * H_SENSITIVITY
	rotation_x = clamp(rotation_x - event.relative.y * V_SENSITIVITY, -89.0, 89.0)
	
	rotation_degrees.y = rotation_y
	camera.rotation_degrees.x = rotation_x

# Aplicar gravedad y salto
func handle_gravity(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

# Manejar movimiento del jugador
func handle_movement(delta):
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction != Vector3.ZERO:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()
"""
# Recopilar nodos del mapa dinámicamente
func collect_map_nodes(root: Node):
	for node in root.get_children():
		if node is Node3D and node.name != "Player":  # Excluir al jugador
			map_nodes.append(node)
		if node.get_child_count() > 0:
			collect_map_nodes(node)

# Administrar carga dinámica del mapa
func handle_map_loading():
	var player_pos = global_transform.origin

	for node in map_nodes:
		if node and node is Node3D:
			var distance = player_pos.distance_to(node.global_transform.origin)
			
			if distance < load_distance and not node in loaded_nodes:
				node.visible = true
				loaded_nodes.append(node)
			
			elif distance > unload_distance and node in loaded_nodes:
				node.visible = false
				loaded_nodes.erase(node)
"""
# Detectar objetos cercanos con RayCast3D
func handle_ray_detection():
	if raycast.is_colliding():
		var hit_object = raycast.get_collider()
		if hit_object:
			highlight_object(hit_object, true)
	else:
		reset_highlight()

# Resaltar un objeto detectado
func highlight_object(obj: Node3D, highlight: bool):
	if obj.name == "Roca" and obj is MeshInstance3D:
		if highlight:
			original_material = obj.material_override
			var new_material = ShaderMaterial.new()
			new_material.shader = load("res://path_to_your_shader.shader")
			new_material.set_shader_param("albedo_color", Color(1, 0, 0))
			obj.material_override = new_material
		else:
			reset_highlight()

# Restaurar el material original
func reset_highlight():
	if original_material:
		var hit_object = raycast.get_collider()
		if hit_object and hit_object is MeshInstance3D:
			hit_object.material_override = original_material
	original_material = null

# Alternar el modo del mouse
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED else Input.MOUSE_MODE_CAPTURED)
"""
