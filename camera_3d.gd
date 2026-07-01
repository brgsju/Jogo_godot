extends Area3D

@onready var camera_foco: Camera3D = $Camera3D

# Quando a Sophia entra na área, ativamos a câmera do obstáculo
func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		camera_foco.make_current()
		print("Câmera focada no obstáculo!")

# Quando a Sophia sai da área (passou do perigo), devolvemos a câmera para ela
func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		# Procura a câmera original dentro da cena da Sophia
		# IMPORTANTE: Troque "Camera3D" abaixo pelo nome exato do nó da câmera que está dentro da cena da sua Sophia!
		var camera_sophia = body.find_child("Camera3D", true, false) as Camera3D
		
		if camera_sophia != null:
			camera_sophia.make_current()
			print("Câmera voltou para a Sophia!")
