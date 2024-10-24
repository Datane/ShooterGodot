extends Node
@onready var audio_stream_player_2d_2 = $AudioStreamPlayer2D
#funcion para poner un delay que no existe en godot por es la cree
func delay(seconds):
	await get_tree().create_timer(seconds).timeout
# Inicialización del nodo
func _ready():
	$".".visible = false  # Ocultar el nodo de interfaz al inicio
	#process_mode = Node.PROCESS_MODE_PAUSABLE  # Permitir pausar el proceso
# Lógica del juego en cada frame
func _physics_process(delta):
	# Si se presiona la tecla "Esc", alternar entre pausar y reanudar
	if Input.is_action_just_pressed("ui_cancel"):
		toggle_pause()
# Función para alternar entre pausar y reanudar el juego
func toggle_pause():
	get_tree().paused = not get_tree().paused  # Cambiar el estado de pausa
	# Si el juego está pausado
	if get_tree().paused:
		# Mostrar el cursor para interactuar con la interfaz
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		$ColorRect.visible = true  # Mostrar la interfaz de pausa
		$".".visible = true  # Mostrar otros elementos de la UI (si es necesario)
	else:
		# Ocultar el cursor y reanudar el control del juego
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		$ColorRect.visible = false  # Ocultar la interfaz de pausa
		$".".visible = false  # Ocultar otros elementos de la UI
# Lógica cuando se presiona un botón de la UI
func _on_button_pressed():
	audio_stream_player_2d_2.play()
	#funcion de delay
	await delay(0.5)  # Espera 2 segundos
	$".".visible = false  # Ocultar la UI
	$ColorRect.visible = false  # Ocultar también el ColorRect
	get_tree().paused = false  # Reanudar el juego
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  # Capturar el cursor para volver al juego
func _on_button_4_pressed():
	audio_stream_player_2d_2.play()
	#funcion de delay
	await delay(0.5)  # Espera 2 segundos
	#funcion para terminar juego
	get_tree().quit()
func _on_button_3_pressed():
	audio_stream_player_2d_2.play()
	#funcion de delay
	await delay(0.5)  # Espera 2 segundos
	get_tree().change_scene_to_file("res://botones.tscn")
