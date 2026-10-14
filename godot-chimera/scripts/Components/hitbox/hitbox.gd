class_name HitBox extends Area3D

signal hit(hurtbox: HurtBox)

# this should be extracted from a data sheet of some kind
@export var damage: float = 10.0

# if the hit should only hit the first target
@export var one_shot: bool = false 

# so we don't need to register hits twice
var already_hit: Array[HurtBox] = []

func _init() -> void:
	# hitboxes can't be hurt
	monitoring = true
	monitorable = false
	area_entered.connect(_on_hit_detected)

func _on_hit_detected(area: Area3D):
	if not area is HurtBox:
		return 
	
	var hurtbox = area as HurtBox
	
	if (already_hit.size() > 0 and one_shot) or already_hit.has(hurtbox) or hurtbox.is_invincible:
		return
	
	already_hit.append(hurtbox)
	hit.emit(hurtbox)
	hurtbox.take_hit(self)

func has_hit() -> bool:
	if already_hit.size() > 0:
		return true
	return false

func reset() -> void:
	already_hit = []
