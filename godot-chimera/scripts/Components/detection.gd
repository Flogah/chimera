class_name Detection extends Area3D

signal body_detected(body)
signal visual_confirmed(body)
signal visual_lost(body)

var bodies_in_range:Array[CharacterBody3D] = []
var bodies_in_vision:Array[CharacterBody3D] = []

var head_offset = Vector3(0.0, 1.5, 0.0)

func _init() -> void:
	# hitboxes can't be hurt
	monitoring = true
	monitorable = false
	
	body_entered.connect(_on_body_in_range)
	body_exited.connect(_on_body_out_of_range)

func _ready() -> void:
	var bodies = get_overlapping_bodies()
	for body in bodies:
		var o = owner
		if body is CharacterBody3D and body != owner:
			bodies_in_range.append(body)
			body_detected.emit(body)

func _on_body_in_range(body: Node3D):
	if body is CharacterBody3D and body != owner:
		# split into acceptable targets
		bodies_in_range.append(body)
		body_detected.emit(body)

func _on_body_out_of_range(body: Node3D):
		if bodies_in_range.has(body):
			bodies_in_range.erase(body)

func _physics_process(delta: float) -> void:
	for body in bodies_in_range:
		if confirm_vision(body) and !bodies_in_vision.has(body):
			bodies_in_vision.append(body)
			visual_confirmed.emit(body)
		elif bodies_in_vision.has(body):
			bodies_in_vision.erase(body)
			visual_lost.emit(body)
	
	visualize_vision()

func confirm_vision(body) -> bool:
	var space_state = get_world_3d().direct_space_state
	
	var query = PhysicsRayQueryParameters3D.create(global_position + head_offset, body.global_position + head_offset)
	var result = space_state.intersect_ray(query)
	if !result.is_empty():
		var collider = result.get("collider")
		if collider == body:
			return true
	return false

func visualize_vision():
	for body in bodies_in_range:
		var col: Color = Color.RED
		if bodies_in_vision.has(body):
			col = Color.GREEN
		Draw3d.line(global_position + head_offset, body.global_position + head_offset, col, 1)
