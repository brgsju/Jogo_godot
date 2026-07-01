extends Area3D

@onready var camera_foco: Camera3D = $Camera3D

func _on_body_entered(body: Node3D) -> void:
	if body.name == "sophia": 
		camera_foco.make_current()
		print("Câmera focada no obstáculo!")

func _on_body_exited(body: Node3D) -> void:
	if body.name == "sophia": 
		# Busca o nó na raiz da cena (world), não dentro da Sophia
		var main_scene = get_tree().current_scene
		var camera_pivot = main_scene.find_child("camera_pivot", true, false)
		
		if camera_pivot:
			var camera_real = camera_pivot.get_node("Camera")
			if camera_real:
				camera_real.make_current()
				print("Câmera voltou para o controle principal!")
			else:
				print("Erro: Nó 'Camera' não encontrado dentro de 'camera_pivot'.")
		else:
			print("Erro: Nó 'camera_pivot' não encontrado no world.")
