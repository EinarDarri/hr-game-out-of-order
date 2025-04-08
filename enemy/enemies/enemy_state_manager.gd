class_name EnemyStateManager extends Node

@export var enemy: Enemy

@export var active_state: EnemyState:
	set(new_state):
		if active_state != null:
			active_state.end_state()
			new_state.start_state()
		active_state = new_state

func _ready() -> void:
	enemy.attack_received.connect(_attack_received)
	active_state.start_state()

func _process(delta: float) -> void:
	active_state.update_state(delta)

func _physics_process(delta: float) -> void:
	active_state.physics_update(delta)

func _attack_received(attack: Attack) -> void:
	active_state.attack_received(attack)
