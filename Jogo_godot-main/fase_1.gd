extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$sophia.sophia_morreu.connect(_on_sophia_morreu)

func _on_sophia_morreu():
	$TelaGameOver.visible = true
	get_tree().paused = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_zonaqueda_body_entered(body: Node3D) -> void:
	if body.name == "sophia":
		# Torna a UI visível (ajuste o caminho do $ se o nó estiver em outro lugar)
		$TelaGameOver.visible = true
		get_tree().paused = true


func _on_button_recomecar_pressed() -> void:
	# Primeiro tiramos o jogo do pause
	get_tree().paused = false 
	# Depois recarregamos a cena
	get_tree().reload_current_scene() # Replace with function body.


func _on_button_sair_menu_pressed() -> void:
	# 1. Tira o jogo do estado de pause
	get_tree().paused = false

	# 2. Troca para a cena do menu. 
	# ATENÇÃO: Apague o texto entre aspas e arraste o arquivo do seu menu 
	# do painel de Arquivos (File System) para dentro dos parênteses 
	# para o Godot preencher o caminho "res://..." exato para você.
	get_tree().change_scene_to_file("res://menu_inicial.tscn")


func _on_static_body_3d_body_entered(body: Node3D) -> void:
	pass # Replace with function body.
