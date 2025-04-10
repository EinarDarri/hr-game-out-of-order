extends EnemyState

@export_group("Other States")
@export var wander_state: EnemyState

func physics_update(delta: float) -> void:
	# Add the gravity. 
	if not enemy.is_on_floor():
		enemy.velocity += enemy.get_gravity() * delta
	else:
		state_manager.active_state = wander_state

func attack_received(_attack: Attack) -> void:
	pass
