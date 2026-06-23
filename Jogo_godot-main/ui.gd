extends CanvasLayer

# Altera o nome depois do $ para o nome exato do seu nó de texto na esquerda
@onready var texto_sorvetes = $Label 

func _on_sophia_contador_alterado(quantidade: int) -> void:
	# Usamos o + para juntar o texto fixo com o número variável
	texto_sorvetes.text = "Vidas: " + str(quantidade)
