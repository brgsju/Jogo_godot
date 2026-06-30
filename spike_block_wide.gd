extends Area3D # Garanta que o script comece com 'extends Area3D'

func _ready() -> void:
	# Conecta o sinal de colisão via código para não ter erro
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if body.name == "sophia":
		if body.has_method("tomar_dano"):
			body.tomar_dano()
