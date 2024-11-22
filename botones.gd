extends Control
#manda a llamar ala funcion audiostream2
@onready var audio_stream_player_2d_2 = $AudioStreamPlayer2D2
#funcion para poner un delay que no existe en godot por es la cree
func delay(seconds):
	await get_tree().create_timer(seconds).timeout
#funcion de boton jugar
func _on_button_pressed():
	#funcion para iniciar el audio en el boton 
	audio_stream_player_2d_2.play()
	#funcion del delay 
	await delay(0.5)  # Espera 2 segundos
	#para ir a el juego
	get_tree().change_scene_to_file("res://mundoPrincipal.tscn")
	

#funcion para salir 
func _on_exit_button_pressed():
	#funcion para audio
	audio_stream_player_2d_2.play()
	#funcion de delay
	await delay(0.5)  # Espera 2 segundos
	#funcion para terminar juego
	get_tree().quit()
