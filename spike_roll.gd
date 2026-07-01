extends Node3D

# Esta função é chamada automaticamente pelo Godot quando algo entra na área
func _on_body_entered(body: Node3D) -> void:
	# Verifica se o objeto que entrou se chama "sophia"
	# Certifique-se de que o nó da sua personagem se chame exatamente "sophia" na árvore
	if body.name == "sophia":
		print("Dano aplicado!")
		
		# Aqui você chama a função que tira vida da Sophia
		# Exemplo: se o script da Sophia tiver uma função chamada 'receber_dano'
		if body.has_method("receber_dano"):
			body.receber_dano(10) # Aplica 10 de dano
