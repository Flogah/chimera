extends CharacterBody3D
class_name Player

@export var speed: float = 5.0
@export var rotation_speed: float = 10.0

@onready var camera_arm: Node3D = %Camera_Arm
@onready var mesh: Node3D = %Mesh

func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity += get_gravity()
	
	var input_vector: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var forward: Vector3 = -camera_arm.global_transform.basis.z
	forward.y = 0.0
	forward = forward.normalized()
	
	var right: Vector3 = camera_arm.global_transform.basis.x.normalized()
	
	var move_vector: Vector3 = right * input_vector.x - forward * input_vector.y
	velocity.x = move_vector.x * speed
	velocity.z = move_vector.z * speed
	
	if move_vector.length_squared() > 0.001:
		var target_angle := atan2(-move_vector.x, -move_vector.z)
		mesh.rotation.y = lerp_angle(mesh.rotation.y, target_angle, rotation_speed * delta)
		
	move_and_slide()
