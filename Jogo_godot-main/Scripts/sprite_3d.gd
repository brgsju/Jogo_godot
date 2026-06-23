extends Sprite3D

# O @export faz essas variáveis aparecerem no Inspecetor (Painel da direita)
@export var velocidade: float = 2.0
@export var limite_fim: float = 50.0      # Posição X onde a nuvem some
@export var limite_inicio: float = -50.0  # Posição X onde ela reaparece

# Variáveis para o efeito de flutuar no vento
@export var altura_flutuacao: float = 0.5
@export var velocidade_flutuacao: float = 1.0

var tempo: float = 0.0
var altura_base: float = 0.0

func _ready() -> void:
	# Quando o jogo começa, ele guarda a altura original da nuvem
	altura_base = position.y

func _process(delta: float) -> void:
	# 1. Faz a nuvem andar para o lado (Eixo X)
	position.x += velocidade * delta
	
	# 2. Faz a nuvem flutuar suavemente para cima e para baixo (Eixo Y)
	tempo += delta
	position.y = altura_base + (sin(tempo * velocidade_flutuacao) * altura_flutuacao)
	
	# 3. O Loop Infinito: Se ela passar do limite final, volta pro limite inicial!
	if position.x > limite_fim:
		position.x = limite_inicio
