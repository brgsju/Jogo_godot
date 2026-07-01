extends CharacterBody3D

@export var velocidade: float = 2.5 # Um pouco mais rápido que o patrulheiro!
@export var gravidade: float = 9.8

var jogador: Node3D = null

func _ready() -> void:
	# Quando o inimigo nasce, ele procura a Sophia pelo grupo "player"
	jogador = get_tree().get_first_node_in_group("player") as Node3D

func _physics_process(delta: float) -> void:
	# 1. Aplica a gravidade
	if not is_on_floor():
		velocity.y -= gravidade * delta

	# 2. Inteligência de Perseguição
	if jogador != null:
		# Calcula a direção da Sophia
		var direcao = jogador.global_position - global_position
		direcao.y = 0 # Ignora a altura para ele não tentar voar ou cavar
		direcao = direcao.normalized()

		# Faz o inimigo olhar para a Sophia (só se ela estiver um pouco distante)
		if direcao.length() > 0.1:
			look_at(global_position + direcao, Vector3.UP)

		# Aplica a velocidade na direção dela
		velocity.x = direcao.x * velocidade
		velocity.z = direcao.z * velocidade
	else:
		# Se a Sophia não for encontrada, ele fica parado
		velocity.x = 0
		velocity.z = 0

	# Executa o movimento
	move_and_slide()

# --- SINAIS DE COLISÃO (Obrigatório conectar os nós de wi-fi neste novo script!) ---

# Quando a Sophia toca no CORPO (Toma dano)
func _on_areadano_body_entered(body: Node3D) -> void:
	if body.has_method("tomar_dano"):
		print("O perseguidor pegou a Sophia!")
		body.tomar_dano()

# Quando a Sophia cai na CABEÇA (Derrota o inimigo)
func _on_areacabeca_body_entered(body: Node3D) -> void:
	if body.has_method("quicar_no_boss"):
		print("Sophia pisou no perseguidor!")
		body.quicar_no_boss() 
		queue_free() # Destrói o inimigo
