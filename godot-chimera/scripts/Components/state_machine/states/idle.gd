extends State

func enter_state(_data: Dictionary = {}) -> void:
	actor.velocity = Vector3.ZERO
	actor.move_and_slide()

func physics_update(_delta: float) -> void:
	if !actor.is_on_floor():
		actor.velocity.y -= 9.8
	
	actor.move_and_slide()
