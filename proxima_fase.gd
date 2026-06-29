extends Area3D

func _on_body_entered(body):
	# Ajustado para o nome exato do seu nó de personagem
	if body.name == "sophia":
		print("oiiiiii")
		# Ajustado para o caminho real da sua cena do jogo
		get_tree().change_scene_to_file("res://fase2.tscn")
