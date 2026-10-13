extends Node
class_name StaminaComponent

@export_range(10.0,300.0,10.0) var max_stamina: float = 100.0
var stamina: float = 100.0

signal changed(new: float)
signal empty

func use(amount: float) -> bool:
	if stamina > 0:
		stamina = stamina - amount
		changed.emit(stamina)
		if stamina <= 0:
			stamina = 0
			empty.emit()
		return true
	return false
