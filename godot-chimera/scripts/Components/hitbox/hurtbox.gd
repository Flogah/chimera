class_name HurtBox extends Area3D

signal hit_received(hitbox: HitBox)

func _init() -> void:
	# hurtboxes can't hit
	monitoring = false
	monitorable = true

func take_hit(hitbox: HitBox) -> void:
	hit_received.emit(hitbox)
	
