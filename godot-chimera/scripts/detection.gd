class_name Detection extends Area3D

signal detected(body)
signal confirmed_visual(body)
signal lost(body)

var bodies_in_range:Array[CharacterBody3D] = []
var bodies_in_vision:Array[CharacterBody3D] = []

func _init() -> void:
	# hitboxes can't be hurt
	#monitoring = true
	#monitorable = false
	body_entered.connect(_on_body_in_range)

func _ready() -> void:
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body is CharacterBody3D:
			bodies_in_range.append(body)
			detected.emit(body)

func _on_body_in_range(body: Node3D):
	if body is CharacterBody3D:
		# split into acceptable targets
		bodies_in_range.append(body)
		detected.emit(body)

func _physics_process(delta: float) -> void:
	for body in bodies_in_range:
		var col:Color
		if confirm_vision(body):
			bodies_in_vision.append(body)
			col = Color.GREEN
			confirmed_visual.emit(body)
		elif bodies_in_vision.has(body):
			col = Color.RED
			bodies_in_vision.erase(body)
			lost.emit(body)
		
		Draw3d.line(global_position, body.global_position, col, 1)

func confirm_vision(body) -> bool:
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(global_position, body.global_position)
	var result = space_state.intersect_ray(query)
	if !result.is_empty():
		var collider = result.get("collider")
		if collider == body:
			return true
	return false
