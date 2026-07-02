extends CharacterBody3D

signal sophia_morreu
signal contador_alterado(quantidade)
var esta_tomando_dano: bool = false
var sorvetes_coletados: int = 1

const SPEED = 300.0
const JUMP_VELOCITY = 15.0
@onready var animator = get_node("sophia/AnimationPlayer")

@export var view : Node3D
var gravity = 0
var movement_velocity : Vector3
var rotation_direction : float

func _physics_process(delta: float) -> void:
	if esta_tomando_dano:
		apply_gravity(delta)
		velocity.y = -gravity
		move_and_slide()
		return 
		
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
	if animator.current_animation == "dano":
		print("dano animcacao")
		return

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
		gravity += 25 * delta
	else:
		if gravity > 0:
			gravity = 0.1

func jump(delta):
	if Input.is_action_just_pressed("jump") and is_on_floor():
		gravity = -JUMP_VELOCITY
			
func pegar_sorvete():
	sorvetes_coletados += 1
	contador_alterado.emit(sorvetes_coletados)
	
func tomar_dano():
	esta_tomando_dano = true
	animator.play("novas_animacoes/dano")

	var direcao_tras = -global_transform.basis.z
	var forca_knockback = 500.0 
	velocity = (direcao_tras + Vector3(0, 0.5, 0)) * forca_knockback * get_process_delta_time()

	sorvetes_coletados -= 1
	if sorvetes_coletados < 0:
		sorvetes_coletados = 0

	contador_alterado.emit(sorvetes_coletados)

	if sorvetes_coletados == 0:
		sophia_morreu.emit()

	await get_tree().create_timer(0.6).timeout
	var material = get_node("sophia/rig/Skeleton3D/Sophia").get_surface_override_material(0)
	if material:
		print("dano cor")
		material.albedo_color = Color(1, 1, 1, 1)
	esta_tomando_dano = false
	
func quicar_no_boss() -> void:
	velocity.y = 8.0

func _on_portal_body_entered(body: Node3D) -> void:
	pass

# --- ADICIONADO PARA O BOSS ---
func levar_dano() -> void:
	tomar_dano()
