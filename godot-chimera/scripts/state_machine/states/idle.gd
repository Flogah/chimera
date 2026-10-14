extends State

func enter_state(_data: Dictionary = {}) -> void:
	actor.velocity = Vector3.ZERO
	actor.move_and_slide()
