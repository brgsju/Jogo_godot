extends Node3D

## Emitted when Gobot's feet hit the ground will running.
@warning_ignore("unused_signal")
signal stepped

## Represents the blending between the walking and running animations.
@export_range(0.0, 1.0, 0.01) var walk_run_blending = 0.0:
	set = set_walk_run_blending

@onready var _animation_tree = %AnimationTree
@onready var _main_state_machine: AnimationNodeStateMachinePlayback = _animation_tree.get("parameters/StateMachine/playback")
@onready var _walk_run_blend_position: String = "parameters/StateMachine/Move/blend_position"
@onready var _attack_one_shot: String = "parameters/AttackOneShot/request"
@onready var _face: Node2D = %GDbotFace

# --- NOVO: Referência ao Sensor de Parede ---
@onready var detector_gridmap = $DetectorGridmap

var acordado: bool = false
var jogador_alvo: Node3D = null # Aqui ele vai guardar quem é a presa dele
@export var velocidade: float = 3.0 # Velocidade da perseguição

func _ready() -> void:
	walk_run_blending = walk_run_blending

func set_walk_run_blending(value: float) -> void:
	walk_run_blending = value
	if not is_node_ready():
		return
	_animation_tree.set(_walk_run_blend_position, walk_run_blending)

## Sets the model to a neutral, action-free state.
func idle() -> void:
	_main_state_machine.travel("Idle")

## Sets the model to a walking or running animation or forward movement.
func move() -> void:
	_main_state_machine.travel("Move")

## Sets the model to an upward-leaping animation, simulating a jump.
func jump() -> void:
	_main_state_machine.travel("Jump")

## Sets the model to a downward animation, imitating a fall.
func fall() -> void:
	_main_state_machine.travel("Fall")

func attack() -> void:
	_animation_tree.set(_attack_one_shot, AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func set_face(face_name: String) -> void:
	_face._set_face(face_name)

func acordar(body: Node3D) -> void:
	if body.name == "sophia" and not acordado:
		acordado = true
		jogador_alvo = body # <-- NOVO: Ele grava a Sophia aqui!
		print("O Boss GDBot ACORDOU!")
		set_face("dizzy")
		move()
		
func _process(delta: float) -> void:
	if acordado and jogador_alvo != null:
		
		# 1. Pega a posição completa da Sophia (X e Z), travando o Y para ele não voar
		var posicao_alvo = Vector3(jogador_alvo.global_position.x, global_position.y, jogador_alvo.global_position.z)
		
		# 2. Faz o Boss olhar na direção dela e corrige o Moonwalk
		if global_position.distance_to(posicao_alvo) > 0.1:
			look_at(posicao_alvo, Vector3.UP)
			rotation.y += PI
		
		# 3. SISTEMA DE PARAR NO GRIDMAP
		var pode_andar = true
		
		# Prevenção de erro: verifica se você lembrou de criar o nó do RayCast3D!
		if detector_gridmap != null and detector_gridmap.is_colliding():
			var colisor = detector_gridmap.get_collider()
			# Verifica se o que ele bateu é um GridMap
			if colisor is GridMap or "GridMap" in colisor.name:
				pode_andar = false
				idle() # Faz o Boss parar e voltar pra animação de descanso
		
		# 4. Movimento Final
		if pode_andar:
			move() # Garante que a animação de corrida toque
			global_position = global_position.move_toward(posicao_alvo, velocidade * delta)
