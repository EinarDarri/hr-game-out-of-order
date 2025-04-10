extends EnemyState

@export_group("Variables")
@export var speed:float

@export_group("Other States")
@export var air_state: EnemyState
@export var attack_state: EnemyState

@export_group("Rays")
@export var LeftGroundRay: RayCast2D
@export var RightGroundRay: RayCast2D

var _dir := Vector2.ZERO
var _currentRAY: RayCast2D

func _update_ground_ray() -> void:
	if _dir.x >= 0:
		_currentRAY = RightGroundRay
	elif _dir.x < 0:
		_currentRAY = LeftGroundRay

func physics_update(delta: float) -> void:
	_dir = (Game.get_player().get_global_position() - enemy.get_global_position()).normalized()

	_update_ground_ray()
	
	if !enemy.is_on_floor():
		state_manager.active_state = air_state
		return
		
	if not _currentRAY.is_colliding():
		enemy.velocity = Vector2.ZERO
	else:
		enemy.velocity.x = _dir.x * speed

func attack_received(_attack: Attack) -> void:
	pass
