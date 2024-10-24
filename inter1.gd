extends ParallaxBackground
"""
var DIR = Vector2(30,38)
var speed = 0.3

func _physics_process(delta):
	scroll_base_offset += DIR * speed * delta
"""
var DIR = Vector2(30, 38)  # Dirección del desplazamiento
var speed = 0.3          # Velocidad del desplazamiento
var limit = Vector2(1500, 1500)  # Limites de repetición en x e y (ajústalo según el tamaño del contorno)


func _physics_process(delta):
	scroll_base_offset += DIR * speed * delta  # Actualiza la posición de desplazamiento

	# Verifica si ha alcanzado los límites en los ejes X o Y
	if scroll_base_offset.x >= limit.x:
		scroll_base_offset.x = 0  # Reinicia en el eje X
	if scroll_base_offset.y >= limit.y:
		scroll_base_offset.y = 0  # Reinicia en el eje Y
