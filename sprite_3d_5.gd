extends Sprite3D

# Configurações do vento
const VELOCIDADE_VENTO = 1.5
const FORCA_VENTO = 0.3

var posicao_inicial: Vector3
var tempo_passado: float = 0.0

func _ready() -> void:
	# Guarda o local exato onde você colocou o background na tela
	posicao_inicial = position

func _process(delta: float) -> void:
	# O tempo vai passando...
	tempo_passado += delta
	
	# Aqui a mágica acontece: o sin() e o cos() fazem a imagem balançar
	# suavemente para os lados e um pouquinho para cima/baixo.
	position.x = posicao_inicial.x + sin(tempo_passado * VELOCIDADE_VENTO) * FORCA_VENTO
	position.y = posicao_inicial.y + cos(tempo_passado * 1.0) * (FORCA_VENTO / 2.0)
