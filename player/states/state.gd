class_name PlayerState extends Node

@onready var player: Player = $"../.."
@onready var stateman: StateManager = $"../"

func start_state() -> void:
	pass

func update_state(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass

func end_state() -> void:
	pass

func gui() -> void:
	pass

func attack_received(_attack: Attack) -> void:
	pass

func can_enter() -> bool:
	return true
