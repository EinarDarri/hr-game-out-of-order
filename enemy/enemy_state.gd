class_name EnemyState extends Node

@export_group("All States Require")
@export var enemy: Enemy
@export var state_manager: EnemyStateManager

func start_state() -> void:
	pass

func update_state(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass

func end_state() -> void:
	pass

func attack_received(_attack: Attack) -> void:
	pass
