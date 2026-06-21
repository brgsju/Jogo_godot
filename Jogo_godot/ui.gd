extends CanvasLayer

@onready var label_contador = $Label

func _on_sophia_contador_alterado(quantidade: Variant) -> void:
	label_contador.text = "Vidas: " + str(quantidade)
