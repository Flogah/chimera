class_name HitBox extends Area3D

signal hit(hurtbox: HurtBox)

# this should be extracted from a data sheet of some kind
@export var damage: float = 10.0

# set to 0: infinite pierece / cleave
# otherwise limits how many targets can be hit by a single attack
@export var max_hit_targets: int = 0 

@export var manual_trigger_only:bool = false

# so we don't need to register hits twice
var registered_hits: Array[HurtBox] = []

func _init() -> void:
	# hitboxes can't be hurt
	monitoring = true
	monitorable = false
	if !manual_trigger_only:
		area_entered.connect(_on_hit_detected)

func manual_trigger_hit():
	var hits = get_overlapping_areas()
	for hit in hits:
		_on_hit_detected(hit)
	reset()

func _on_hit_detected(area: Area3D):
	if not area is HurtBox:
		return 
	var hurtbox = area as HurtBox
	
	if max_hit_targets != 0 and registered_hits.size() > max_hit_targets:
		return
	
	registered_hits.append(hurtbox)
	hit.emit(hurtbox)
	hurtbox.take_hit(self)

func has_hit() -> bool:
	if registered_hits.size() > 0:
		return true
	return false

func reset() -> void:
	registered_hits = []
