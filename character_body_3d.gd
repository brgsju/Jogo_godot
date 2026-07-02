extends CharacterBody3D


signal sophia_morreu
# Cria um sinal para avisar a interface
signal contador_alterado(quantidade)
var esta_tomando_dano: bool = false
# Variável para guardar quantos sorvetes/vidas ela tem
var sorvetes_coletados: int = 1

const SPEED = 300.0
const JUMP_VELOCITY = 15.0
@onready var animator = get_node("sophia/AnimationPlayer")

@export var view : Node3D
var gravity = 0
var movement_velocity : Vector3
var rotation_direction : float


func _physics_process(delta: float) -> void:
	if esta_tomando_dano: # Se tomou dano, ignora os controles e apenas desliza
		apply_gravity(delta)
		velocity.y = -gravity
		move_and_slide()
		return # Pula o resto da função (handle_input, etc)
		
	handle_input(delta)
	apply_gravity(delta)
	jump(delta)
	handle_animations()
	
	var applied_velocity : Vector3
	applied_velocity = velocity.lerp(movement_velocity, delta * 10)
	applied_velocity.y = -gravity

	velocity = applied_velocity

	move_and_slide()
	
	if Vector2(velocity.z, velocity.x).length() > 0:
		rotation_direction = Vector2(velocity.z, velocity.x).angle()
	
	rotation.y = lerp_angle(rotation.y, rotation_direction, delta * 10)

func handle_input(delta):
	var input := Vector3.ZERO
	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward", "move_backward")
	
	input = input.rotated(Vector3.UP, view.rotation.y).normalized()
	
	velocity = input * SPEED * delta
	
func handle_animations():
	# Se o animator já estiver tocando "dano", não faça nada (deixa ele terminar)
	if animator.current_animation == "dano":
		print("dano animcacao")
		return

	# Caso contrário, mantém a sua lógica original
	if is_on_floor():
		if abs(velocity.x) > 1 or abs(velocity.z) > 1:
			animator.play("Run", 0.3)
		else:
			animator.play("Idle", 0.3)
	else:
		animator.play("Jump", 0.3)
		
	if !is_on_floor() and gravity > 2:
		animator.play("Fall", 0.3)

func apply_gravity(delta):
	if not is_on_floor():
		# Se está caindo, aumenta a gravidade
		gravity += 25 * delta
	else:
		# Se encostou no chão, zera o acúmulo de gravidade!
		# Mantemos 0.1 apenas para o Godot ter certeza de que ela está grudada no chão
		if gravity > 0:
			gravity = 0.1

func jump(delta):
	# Se apertou pular e está no chão, joga a gravidade pra cima
	if Input.is_action_just_pressed("jump") and is_on_floor():
		gravity = -JUMP_VELOCITY
			
# O sorvete vai chamar essa função quando encostar nela
func pegar_sorvete():
	sorvetes_coletados += 1
	# Avisa a interface que o número mudou!
	contador_alterado.emit(sorvetes_coletados)
	
func tomar_dano():
	# 1. Animação de dano
	esta_tomando_dano = true # Bloqueia o input
	animator.play("novas_animacoes/dano")
	esta_tomando_dano = true # Bloqueia o input
		# ... (resto do seu código continua igual)

	# 2. Lógica de Knockback
	# Calcula a direção oposta à frente da Sophia (eixo Z negativo)
	var direcao_tras = -global_transform.basis.z
	# Define a força do empurrão
	var forca_knockback = 500.0 
	# Aplica o impulso na velocidade. 
	# Usamos o 'direcao_tras' e adicionamos um pouco de altura (0.5) para dar um pulo
	velocity = (direcao_tras + Vector3(0, 0.5, 0)) * forca_knockback * get_process_delta_time()

	# 3. Lógica de vida
	sorvetes_coletados -= 1
	if sorvetes_coletados < 0:
		sorvetes_coletados = 0

	contador_alterado.emit(sorvetes_coletados)

	if sorvetes_coletados == 0:
		sophia_morreu.emit()

	# 4. Ajuste visual (Reset da cor)
	await get_tree().create_timer(0.6).timeout
	var material = get_node("sophia/rig/Skeleton3D/Sophia").get_surface_override_material(0)
	if material:
		print("dano cor")
		material.albedo_color = Color(1, 1, 1, 1)
	esta_tomando_dano = false # Libera o input novamente
	
# Adicione no final do script da Sophia
func quicar_no_boss() -> void:
	# Esse é o impulso do quique! Pode aumentar se achar fraco.
	velocity.y = 8.0


func _on_portal_body_entered(body: Node3D) -> void:
	pass # Replace with function body.
