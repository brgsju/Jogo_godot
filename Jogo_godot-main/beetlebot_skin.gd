extends CharacterBody3D

const SPEED = 2.0
var direcao = 1 # 1 anda para um lado, -1 anda para o outro
var gravidade = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta):
	# 1. Aplica a gravidade para ele ficar no chão
	if not is_on_floor():
		velocity.y -= gravidade * delta
		
	# 2. Faz ele andar na direção atual (Eixo X)
	velocity.x = direcao * SPEED
	
	# 3. Aplica o movimento
	move_and_slide()
	
	# 4. Se ele bater em uma parede, ele inverte a direção e vira o corpo
	if is_on_wall():
		direcao = direcao * -1
		rotation_degrees.y += 180 # Gira o modelo 3D para olhar pro outro lado


# --- SINAIS DE COLISÃO ---

# Quando a Sophia encostar no corpo do besouro...
func _on_areadano_body_entered(body: Node3D) -> void:
	if body.name == "NomeDaSuaPersonagem": # TROQUE PELO NOME EXATO DO NÓ DA SOPHIA
		print("Besouro machucou a Sophia!")
		# Coloque a função de dano aqui depois

# Quando a Sophia encostar/pular na cabeça do besouro...
func _on_areacabeca_body_entered(body: Node3D) -> void:
	if body.name == "NomeDaSuaPersonagem": # TROQUE PELO NOME EXATO DO NÓ DA SOPHIA
		print("Sophia esmagou o besouro!")
		queue_free() # Deleta o besouro da cena
