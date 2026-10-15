extends CharacterBody3D

@onready var nav_agent: NavigationAgent3D = %NavigationAgent3D
@onready var hurt_box: HurtBox = %HurtBox
@onready var hit_box: HitBox = %HitBox
@onready var state_machine: StateMachine = %StateMachine
@onready var detection: Detection = %Detection

@export var patrol_parent: Node3D
var patrol_points:Array[Node3D]

var has_target: bool = false
var target_pos: Vector3
var speed: float = 3.0

func _ready() -> void:
	hurt_box.hit_received.connect(get_hurt)
	hit_box.hit.connect(hit_something)
	
	if patrol_parent:
		for child in patrol_parent.get_children():
			patrol_points.append(child)
		
		state_machine.change_state("patrol", {"patrol_points": patrol_points})

func get_hurt(hitbox: HitBox):
	if hitbox == hit_box:
		return
	
	var blast_dir:Vector3 = (hitbox.global_position - global_position).normalized()
	blast_dir.y = 0.5
	
	velocity = blast_dir.normalized() * 50.0
	
	print(name + ": I have been hurt!")

func hit_something(hurtbox: HurtBox):
	if hurtbox == hurt_box:
		return
	
	print(name + ": I hit something!")
