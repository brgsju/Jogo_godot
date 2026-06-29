extends Node3D

@export_group("Properties")
@export var target: CharacterBody3D

@export_group("Zoom")
# Ajuste os limites para permitir movimento
@export var zoom_minimum = 5.0 
@export var zoom_maximum = 25.0 
@export var zoom_speed = 10.0
@export var zoom_step = 2.0 # Distância que o scroll do mouse avança por "clique"

@export_group("Rotation")
@export var rotation_speed = 120.0
@export var min_rotation_x = -30.0
@export var max_rotation_x = -5.0

var camera_rotation: Vector3
var zoom = 15.0 # Valor inicial dentro dos limites definidos

@onready var camera = $Camera

func _ready():
	camera_rotation = rotation_degrees # Initial rotation

func _physics_process(delta):
	# Set position and rotation to targets
	if target:
		self.position = self.position.lerp(target.position, delta * 4)
	
	rotation_degrees = rotation_degrees.lerp(camera_rotation, delta * 6)
	camera.position = camera.position.lerp(Vector3(0, 0, zoom), 8 * delta)
	
	handle_input(delta)

# Handle input
func handle_input(delta):
	# Rotation
	var input := Vector3.ZERO
	
	input.y = Input.get_axis("camera_left", "camera_right")
	input.x = Input.get_axis("camera_up", "camera_down")
	
	camera_rotation += input.limit_length(1.0) * rotation_speed * delta
	camera_rotation.x = clamp(camera_rotation.x, min_rotation_x, max_rotation_x)
	
	# Zooming (teclado ou controle)
	var zoom_input = Input.get_axis("zoom_in", "zoom_out")
	if zoom_input != 0:
		zoom += zoom_input * zoom_speed * delta
		# Corrigido: Ordem correta do clamp
		zoom = clamp(zoom, zoom_minimum, zoom_maximum)

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			# Corrigido: Remoção do lerpf, substituição por subtração/adição direta
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				zoom -= zoom_step 
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				zoom += zoom_step 
			
			# Corrigido: Ordem correta do clamp
			zoom = clamp(zoom, zoom_minimum, zoom_maximum)
				
