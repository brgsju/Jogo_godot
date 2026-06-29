extends CharacterBody3D

@onready var _animation_tree: AnimationTree = %AnimationTree
@onready var _hurt_shot_path: String = "parameters/HurtShot/request"

# Variáveis de movimento
@export var speed: float = 3.0

# 2. Laço físico rodando frame a frame
func _physics_process(delta: float) -> void:
	
	# Define o vetor de direção (neste exemplo, andando reto para frente no eixo Z)
	var direction = (transform.basis * Vector3(0, 0, 1)).normalized()
	
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	# Trava a velocidade no eixo Y para garantir que ele flutue na mesma altura
	velocity.y = 0

	# 3. Executa a movimentação resolvendo colisões
	move_and_slide()

## Play a OneShot hurt animation.
func hurt() -> void:
	_animation_tree.set(_hurt_shot_path, true)

func _on_areadano_body_entered(_body: Node3D) -> void:
	pass
