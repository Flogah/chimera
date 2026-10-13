extends State

@onready var idle_timer: Timer = $idleTimer

func enter_state(_data: Dictionary = {}) -> void:
	actor.velocity = Vector3.ZERO
	actor.move_and_slide()
	idle_timer.start(randf_range(.5, 1.5))

func _on_timer_timeout() -> void:
	switch_state.emit("random_walk")
