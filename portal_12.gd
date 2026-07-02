extends Area3D

# O Godot vai abrir uma caixinha no Inspetor com esse caminho. 
# Já deixei configurado para a fase 21 como você pediu!
@export var proxima_fase: String = "res://fase21.tscn"

func _on_body_entered(body: Node3D) -> void:
	# Verifica se quem encostou no portal foi a Sophia
	if body.name == "sophia":
		print("A Sophia entrou no portal! Carregando a próxima fase...")
		get_tree().change_scene_to_file(proxima_fase)
