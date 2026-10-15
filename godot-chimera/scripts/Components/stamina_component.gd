extends Node
class_name StaminaComponent

@export_range(10.0,300.0,10.0) var max_stamina: float = 100.0
@export_range(0.1,100.0,0.1) var regeneraton_amount: float = 10.0
@export_range(0.1,10.0,0.1) var regeneration_delay: float = 2.0

var stamina: float = 100.0
var regenerating: bool = false
var delay: float = 0.0

signal changed(new: float)
signal empty

func _process(delta: float) -> void:
	if delay >= regeneration_delay:
		regenerate(delta)
	else:
		delay += delta

func use(amount: float) -> bool:
	if stamina > 0:
		delay = 0.0
		stamina = stamina - amount
		changed.emit(stamina)
		if stamina <= 0:
			stamina = 0
			empty.emit()
		return true
	return false

func regenerate(delta: float):
	stamina += regeneraton_amount * delta
	changed.emit()
