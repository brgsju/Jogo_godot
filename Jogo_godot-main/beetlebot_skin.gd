extends CharacterBody3D

const SPEED = 2.0
var direcao = 1 # 1 para direita, -1 para esquerda
var andando = true
var gravidade = ProjectSettings.get_setting("physics/3d/default_gravity")

# Novo cronômetro para as ações
var tempo_acao = 0.0 

@onready var sensor_chao = $RayCast3D 

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravidade * delta
		
	# 1. Diminui o cronômetro a cada frame
	tempo_acao -= delta
	if tempo_acao <= 0:
		sortear_acao()
		
	# 2. Aplica o movimento se estiver no estado "andando"
	if andando:
		velocity.x = direcao * SPEED
	else:
		velocity.x = 0
		
	move_and_slide()
	
	# 3. Segurança: Só vira pelo buraco ou parede se estiver andando
	if andando and (is_on_wall() or not sensor_chao.is_colliding()):
		inverter_direcao()
		# Reseta o tempo para ele não travar
		tempo_acao = randf_range(1.0, 2.0) 


func sortear_acao():
	# Define que a próxima ação vai durar entre 1 e 3 segundos
	tempo_acao = randf_range(1.0, 3.0) 
	
	# Sorteia um número: 0, 1 ou 2
	var sorteio = randi() % 3 
	
	if sorteio == 0:
		andando = false # Para para descansar
	elif sorteio == 1:
		andando = true  # Continua andando para onde já olhava
	elif sorteio == 2:
		andando = true
		inverter_direcao() # Vira e anda pro outro lado


func inverter_direcao():
	direcao = direcao * -1
	rotation_degrees.y += 180


# --- SINAIS DE COLISÃO ---

func _on_areadano_body_entered(body: Node3D) -> void:
	if body.name == "sophia": 
		print("Besouro machucou a Sophia!")

func _on_areacabeca_body_entered(body: Node3D) -> void:
	if body.name == "sophia": 
		print("Sophia esmagou o besouro!")
		queue_free()
