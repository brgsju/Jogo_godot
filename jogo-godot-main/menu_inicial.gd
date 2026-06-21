extends Control

func _ready():
	pass

func _process(delta):
	pass


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file('res://fase1.tscn') # Replace with function body.


func _on_historia_pressed() -> void:
	pass # Replace with function body.


func _on_sair_pressed() -> void:
	get_tree().quit()
