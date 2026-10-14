class_name HurtBox extends Area3D

signal hit_received(hitbox: HitBox)

@export var is_invincible: bool

func _init() -> void:
	# hurtboxes can't hit
	monitoring = false
	monitorable = true

func take_hit(hitbox: HitBox) -> void:
	if is_invincible:
		return
	
	hit_received.emit(hitbox)
	
