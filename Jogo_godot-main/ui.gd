extends CanvasLayer

# Usar @export elimina a necessidade de caminhos fixos com $
@export var texto_sorvetes: Label 

func _on_sophia_contador_alterado(quantidade: int) -> void:
	# Esta condição impede o jogo de travar se você esquecer de arrastar o nó
	if texto_sorvetes != null:
		texto_sorvetes.text = str(quantidade)
	else:
		print("Aviso de segurança: O nó de texto não foi associado no Inspetor!")
