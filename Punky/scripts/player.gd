extends CharacterBody3D
class_name Player

@export var SPEED : float = 5.0
@export var JUMP_VELOCITY : float = 4.5
@export var rotation_speed : float = 0.1

var input_dir : Vector2
var direction : Vector3
var target_rotation : float
var just_jumped : bool

@onready var raycast: RayCast3D = RayCast3D.new()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta;

	# Handle jump.
	if Input.is_action_just_pressed("player_jump") and is_on_floor():
		just_jumped = true
		velocity.y = JUMP_VELOCITY
	
	else:
		just_jumped = false

	# Get Input.
	input_dir = Input.get_vector("player_left", "player_right", "player_up", "player_down") 
	direction= (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		target_rotation = atan2(-direction.x, -direction.z) + PI
		$Mesh.rotation.y = lerp_angle($Mesh.rotation.y, target_rotation, rotation_speed)
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT and !StateManager.in_dialogue():
			handle_mouse_click(event.position)

func handle_mouse_click(mouse_position) -> void:
	var camera: Camera3D = get_viewport().get_camera_3d()
	var from: Vector3 = camera.project_ray_origin(mouse_position)
	var dir: Vector3 = camera.project_ray_normal(mouse_position)

	var ray_length: float = 1000.0
	var to: Vector3 = from + dir * ray_length

	var query = PhysicsRayQueryParameters3D.create(from, to)
	var collision = get_world_3d().direct_space_state.intersect_ray(query)
	print(collision)
	
	if collision:
		var collider = collision.collider
		
		if collider and collider.has_node("Interactable"):
			var interactable = collider.get_node("Interactable")
			if interactable:
				interactable.interact()
