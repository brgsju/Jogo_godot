extends Area3D

func _on_body_entered(body: Node3D) -> void:
	if body.name == "sophia":
		# Se a Sophia tiver uma lógica interna de morte, chame-a:
		if body.has_method("morrer"):
			body.morrer()
		
		# Opcional: Se você quiser garantir que a fase saiba da queda
		# via sinal, o ideal é conectar o sinal na própria fase.
