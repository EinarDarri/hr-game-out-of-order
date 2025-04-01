class_name PlayerState extends Node

@onready var player: Player = $"../.."
@onready var stateman: StateManager = $"../"

func start_state() -> void:
	pass

func update_state(delta: float) -> void:
	pass
	
func end_state() -> void:
	pass
