class_name NonPlayableCharacter
extends CharacterBody2D

@onready var state_machine: NodeStateMachine = $StateMachine

@export var min_walk_cycle: int = 2
@export var max_walk_cycle: int = 5

var walk_cycles: int
var current_walk_cycle: int

signal is_pushed(direction: Vector2, force: float)

func on_pushed(direction: Vector2, force: float):
	is_pushed.emit(direction, force)
	state_machine.transition_to("Pushed")
	
