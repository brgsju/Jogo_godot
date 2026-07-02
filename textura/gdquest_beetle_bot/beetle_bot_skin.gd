extends CharacterBody3D

# --- Variáveis Principais ---
@export var velocidade = 2.0
@export var tempo_patrulha = 3.0 # <-- NOVO: Quantos segundos ele anda antes de virar
var tempo_atual = 0.0            # <-- NOVO: Cronômetro interno do besouro

var gravidade = ProjectSettings.get_setting("physics/3d/default_gravity")

# --- Referências dos Nós ---
@onready var detector_penhasco = $DetectorPenhasco
@onready var animation_player = $beetle_bot/AnimationPlayer

func _ready() -> void:
	if has_node("Hitbox"):
		var hitbox_node = get_node("Hitbox")
		if hitbox_node is Area3D:
			hitbox_node.body_entered.connect(_ao_encostar_no_corpo)
			hitbox_node.area_entered.connect(_ao_encostar_na_area)
		else:
			print("ERRO: O nó 'Hitbox' precisa ser do tipo Area3D!")
	else:
		print("ERRO: Não encontrei nenhum nó chamado 'Hitbox'.")

func _physics_process(delta: float) -> void:
	# 1. Gravidade
	if not is_on_floor():
		velocity.y -= gravidade * delta

	# --- NOVO: Lógica do Cronômetro ---
	tempo_atual += delta # Aumenta o tempo baseado nos quadros do jogo

	# 2. Patrulha (Adicionamos a checagem do tempo_atual aqui!)
	if is_on_wall() or not detector_penhasco.is_colliding() or tempo_atual >= tempo_patrulha:
		dar_meia_volta()

	# 3. Movimento
	var direcao = transform.basis.z 
	velocity.x = direcao.x * velocidade
	velocity.z = direcao.z * velocidade

	move_and_slide()
	
	# 4. Sistema de Animação
	if animation_player.has_animation("walk"):
		animation_player.play("walk")

# --- Funções Auxiliares ---

func dar_meia_volta():
	rotation.y += PI
	tempo_atual = 0.0 # <-- NOVO: Zera o cronômetro sempre que ele dá meia-volta!

func _ao_encostar_no_corpo(body: Node3D) -> void:
	if body.has_method("tomar_dano"):
		body.tomar_dano()

func _ao_encostar_na_area(area: Area3D) -> void:
	if "ROTATION" in area:
		area.queue_free()
