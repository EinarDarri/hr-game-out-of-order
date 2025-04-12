extends EnemyState

@export_group("Variables")
@export var speed:float

@export_group("Other States")
@export var air_state: EnemyState
@export var attack_state: EnemyState

@export_group("Rays")
@export var LeftGroundRay: RayCast2D
@export var RightGroundRay: RayCast2D

@export_group("Other")
@export var attack_area: Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"

var _dir := Vector2.ZERO
var _currentRAY: RayCast2D

func start_state() -> void:
	animated_sprite_2d.play("walk")

func _update_ground_ray() -> void:
	if _dir.x >= 0:
		_currentRAY = RightGroundRay
	elif _dir.x < 0:
		_currentRAY = LeftGroundRay

func physics_update(delta: float) -> void:
	_dir = (Game.get_player().get_global_position() - enemy.get_global_position())
	_dir.y = 0
	_dir = _dir.normalized()
	animated_sprite_2d.flip_h = _dir.x <= 0

	_update_ground_ray()
	
	if !enemy.is_on_floor():
		state_manager.active_state = air_state
		return
		
	if not _currentRAY.is_colliding():
		enemy.velocity = Vector2.ZERO
		animated_sprite_2d.play("idle")
	else:
		enemy.velocity.x = _dir.x * speed
		if animated_sprite_2d.animation == &"idle":
			animated_sprite_2d.play("walk")
	if not attack_area.get_overlapping_bodies().is_empty():
		state_manager.active_state = attack_state

func attack_received(_attack: Attack) -> void:
	pass
