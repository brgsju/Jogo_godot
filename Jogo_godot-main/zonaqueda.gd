extends Area3D

func _on_area_3d_body_entered(body: Node3D) -> void:
	# Substitua pelo nome exato do nó do seu personagem (ex: "sophia" ou "Player")
	if body.name == "sophia": 
		# Insira o caminho correto do arquivo da sua segunda fase
		get_tree().change_scene_to_file("res://fase2.tscn")
