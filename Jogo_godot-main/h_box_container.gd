extends HBoxContainer

# Apontamos para a nova barra de vida em vez do texto antigo.
# Atenção: se os nomes na sua lista da esquerda estiverem diferentes, mude aqui depois do $
@onready var barra_vida = $HBoxContainer/ProgressBar

func _on_sophia_contador_alterado(quantidade: Variant) -> void:
	# A barra vai encher ou esvaziar baseada na quantidade que receber da Sophia!
	barra_vida.value = quantidade
