extends CharacterBody3D

@export var velocidade: float = 3.5
@export var gravidade: float = 9.8
@export var vida: int = 3 

var jogador: Node3D = null
var perseguindo: bool = false # Nova variável para controlar o estado do Boss!

func _ready() -> void:
	jogador = get_tree().get_first_node_in_group("player") as Node3D

func _physics_process(delta: float) -> void:
	# Gravidade
	if not is_on_floor():
		velocity.y -= gravidade * delta

	# Movimento de perseguição APENAS se o jogador existir E o Boss estiver perseguindo
	if jogador != null and perseguindo:
		var direcao = jogador.global_position - global_position
		direcao.y = 0 
		direcao = direcao.normalized()

		if direcao.length() > 0.1:
			look_at(global_position + direcao, Vector3.UP)

		velocity.x = direcao.x * velocidade
		velocity.z = direcao.z * velocidade
	else:
		# Se não estiver perseguindo, ele fica parado no lugar
		velocity.x = 0
		velocity.z = 0

	move_and_slide()

# --- SINAIS DE BATALHA ---

func _on_area_dano_corpo_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		print("Fim de jogo! O Boss te pegou!")
		get_tree().reload_current_scene()

func _on_area_ponto_fraco_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		vida -= 1
		print("Acertou! Vida do Boss: ", vida)
		
		if body.has_method("quicar_no_boss"):
			body.quicar_no_boss()
		
		if vida <= 0:
			print("Boss Derrotado!")
			queue_free()

# --- SINAIS DO CAMPO DE VISÃO ---

# Quando a Sophia ENTRAR no círculo gigante, o Boss começa a correr atrás dela
func _on_area_visao_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		print("O Boss viu a Sophia! Iniciando perseguição...")
		perseguindo = true

# Quando a Sophia SAIR do círculo gigante (Opcional: se quiser que ele desista se ela fugir)
func _on_area_visao_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		print("A Sophia conseguiu despistar o Boss!")
		perseguindo = false
