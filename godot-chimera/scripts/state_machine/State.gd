class_name State extends Node

# must be called to switch to a different state.
signal switch_state(state: State)

func enter_state() -> void:
	# always happens first when entering the state
	pass

func exit_state() -> void:
	# always happens after the state is done, right before the new state enters
	pass

func update(_delta: float) -> void:
	# replaces process
	pass

func physics_update(_delta: float) -> void:
	# replaces physics_process
	pass
