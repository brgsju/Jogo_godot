extends Node3D

# Colocamos a variável do WorldEnvironment junto com as outras variáveis no topo
@onready var world_env = $WorldEnvironment 

# Juntamos tudo dentro de um único _ready()
func _ready() -> void:
	# Seu código original
	$sophia.sophia_morreu.connect(_on_sophia_morreu)
	
	# --- NOVO CÓDIGO DO FUNDO DO CÉU ---
	# ATENÇÃO: Substitua o caminho abaixo pelo caminho real da sua imagem!
	var textura_ceu = load("res://caminho_para_sua_imagem.png")
	
	if world_env.environment and world_env.environment.sky:
		var material = world_env.environment.sky.sky_material
		if material is PanoramaSkyMaterial:
			material.panorama = textura_ceu
			print("Fundo ajeitado com sucesso!")
		else:
			print("O material do céu não é um PanoramaSkyMaterial.")
	# -----------------------------------

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
	get_tree().reload_current_scene() 

func _on_button_sair_menu_pressed() -> void:
	# 1. Tira o jogo do estado de pause
	get_tree().paused = false

	# 2. Troca para a cena do menu. 
	get_tree().change_scene_to_file("res://menu_inicial.tscn")

func _on_static_body_3d_body_entered(body: Node3D) -> void:
	pass
