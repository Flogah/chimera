class_name StateMachine extends Node

@export var initial_state:State
@onready var actor: CharacterBody3D = owner

var active_state: State

func _ready() -> void:
	for child_state:State in get_children():
		child_state.switch_state.connect(change_state)
		child_state.actor = actor
	
	change_state(initial_state)

func _process(delta: float) -> void:
	if active_state: active_state.update(delta)

func _physics_process(delta: float) -> void:
	if active_state: active_state.physics_update(delta)

func change_state(new_state:State) -> void:
	if active_state == new_state:
		return
	
	if active_state:
		active_state.exit_state()
	
	active_state = new_state
	
	if active_state:
		active_state.enter_state()
