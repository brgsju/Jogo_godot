extends Node3D

@warning_ignore("unused_signal")
signal stepped

@export_range(0.0, 1.0, 0.01) var walk_run_blending = 0.0:
	set = set_walk_run_blending

@onready var _animation_tree = %AnimationTree
@onready var _main_state_machine: AnimationNodeStateMachinePlayback = _animation_tree.get("parameters/StateMachine/playback")
@onready var _walk_run_blend_position: String = "parameters/StateMachine/Move/blend_position"
@onready var _attack_one_shot: String = "parameters/AttackOneShot/request"
@onready var _face: Node2D = %GDbotFace
@onready var detector_gridmap = $DetectorGridmap

var acordado: bool = false
var jogador_alvo: Node3D = null
var vida: int = 3
var pode_levar_dano: bool = true

@export var velocidade: float = 3.0

func _ready() -> void:
	walk_run_blending = walk_run_blending

func set_walk_run_blending(value: float) -> void:
	walk_run_blending = value
	if not is_node_ready():
		return
	_animation_tree.set(_walk_run_blend_position, walk_run_blending)

func idle() -> void:
	_main_state_machine.travel("Idle")

func move() -> void:
	_main_state_machine.travel("Move")

func set_face(face_name: String) -> void:
	_face._set_face(face_name)

func acordar(body: Node3D) -> void:
	if body.name == "sophia" and not acordado:
		acordado = true
		jogador_alvo = body
		print("O Boss GDBot ACORDOU!")
		set_face("dizzy")
		move()

			
func _on_hitbox_cabeca_body_entered(body: Node3D) -> void:
	if body.name == "sophia":
		vida -= 1
		print("Dano recebido! Vida: ", vida)
		set_face("dizzy")
		
		global_position -= transform.basis.z * 2
		
		if vida <= 0:
			print("Boss Derrotado! Indo para o menu final...")
			# --- ADICIONE ISSO ---
			get_tree().change_scene_to_file("res://menufinal.tscn")
			queue_free()
			
			
			

func _process(delta: float) -> void:
	if acordado and jogador_alvo != null:
		var posicao_alvo = Vector3(jogador_alvo.global_position.x, global_position.y, jogador_alvo.global_position.z)
		
		if global_position.distance_to(posicao_alvo) > 0.1:
			look_at(posicao_alvo, Vector3.UP)
			rotation.y += PI
		
		var pode_andar = true
		if detector_gridmap != null and detector_gridmap.is_colliding():
			var colisor = detector_gridmap.get_collider()
			if colisor is GridMap or "GridMap" in colisor.name:
				pode_andar = false
				idle()
		
		if pode_andar:
			move()
			global_position = global_position.move_toward(posicao_alvo, velocidade * delta)

# --- ADICIONADO PARA O DANO NA SOPHIA ---
func _on_hitbox_corpo_body_entered(body: Node3D) -> void:
	if body.name == "sophia":
		if body.has_method("levar_dano"):
			body.levar_dano()
			print("Sophia tomou dano ao encostar no Boss!")
			
		global_position += transform.basis.z * 2.0
