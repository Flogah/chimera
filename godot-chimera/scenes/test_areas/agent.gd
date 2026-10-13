extends CharacterBody3D

@onready var nav_agent: NavigationAgent3D = %NavigationAgent3D

var has_target: bool = false
var target_pos: Vector3
var speed: float = 3.0
