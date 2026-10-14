extends State

@export var nav_agent: NavigationAgent3D
var target:Node3D

func enter_state(_data: Dictionary = {}) -> void:
	target = _data.get("target")
	
	nav_agent.target_position = target.global_position
	
	nav_agent.velocity_computed.connect(on_velocity_computed)

func physics_update(_delta: float) -> void:
	if nav_agent.is_navigation_finished():
		switch_state.emit("attack")
	elif !nav_agent.target_position.is_equal_approx(target.global_position):
		nav_agent.target_position = target.global_position
	
	var next_path_pos: Vector3 = nav_agent.get_next_path_position()
	var dir = actor.global_position.direction_to(next_path_pos)
	var new_velocity = dir * actor.speed

	if nav_agent.avoidance_enabled:
		nav_agent.set_velocity(new_velocity)
	else:
		on_velocity_computed(new_velocity)
	
	var rot_speed = 4.0
	var target_rot = dir.signed_angle_to(Vector3.MODEL_FRONT, Vector3.DOWN)
	if  abs(target_rot - actor.rotation.y) > deg_to_rad(60):
		rot_speed = 20.0
	actor.rotation.y = move_toward(actor.rotation.y, target_rot, _delta * rot_speed)
	
	actor.move_and_slide()

func exit_state() -> void:
	nav_agent.velocity_computed.disconnect(on_velocity_computed)

func on_velocity_computed(safe_velocity: Vector3) -> void:
	actor.velocity = safe_velocity
