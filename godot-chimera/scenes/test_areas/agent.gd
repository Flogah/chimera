extends CharacterBody3D

signal target_acquired(target)
signal target_lost(target)

@onready var nav_agent: NavigationAgent3D = %NavigationAgent3D
@onready var hurt_box: HurtBox = %HurtBox
@onready var hit_box: HitBox = %HitBox
@onready var state_machine: StateMachine = %StateMachine
@onready var detection: Detection = %Detection

@export var patrol_parent: Node3D
var patrol_points:Array[Node3D]

var target:CharacterBody3D

var speed: float = 3.0

func _ready() -> void:
	hurt_box.hit_received.connect(get_hurt)
	hit_box.hit.connect(hit_something)
	
	target_acquired.connect(func(): state_machine.change_state("follow", {"target": target}))
	target_lost.connect(func(): state_machine.change_state("follow"))

func get_hurt(hitbox: HitBox):
	if hitbox == hit_box:
		return
	
	print(name + ": I have been hurt!")

func hit_something(hurtbox: HurtBox):
	if hurtbox == hurt_box:
		return
	
	print(name + ": I hit " + hurtbox.owner.name)

func make_target(body: CharacterBody3D):
	if body is Player:
		target = body
		target_acquired.emit(target)
		

func lose_target():
	target_lost.emit(target)
	target = null
	
