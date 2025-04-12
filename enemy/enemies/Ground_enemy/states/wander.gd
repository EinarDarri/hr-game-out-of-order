extends EnemyState

@export_group("Variables")
@export var speed:float

@export_group("Other States")
@export var Air_state: EnemyState
@export var Chase_state: EnemyState

@export_group("Rays")
@export var WallRay: RayCast2D
@export var LeftGroundRay: RayCast2D
@export var RightGroundRay: RayCast2D

@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"

var _active = true
var _dir := Vector2.RIGHT
var _currentRAY: RayCast2D

func _ready() -> void:
	_currentRAY = RightGroundRay
		
func _update_ground_ray() -> void:
	if _dir.x >= 0:
		_currentRAY = RightGroundRay
	elif _dir.x < 0:
		_currentRAY = LeftGroundRay

func start_state() -> void:
	_active = true
	animated_sprite_2d.play("walk")

func physics_update(delta: float) -> void:
	if !enemy.is_on_floor():
		state_manager.active_state = Air_state
		return
		
	if !_currentRAY.is_colliding():
		_dir *= -1
		WallRay.target_position *= -1
		_update_ground_ray()
		
	if WallRay.is_colliding():
		
		if enemy.velocity.x == 0:
			WallRay.target_position *= -1
			_dir *= -1
			_update_ground_ray()
			
		enemy.velocity.x = 0
		
	else:
		enemy.velocity.x = _dir.x * speed

func end_state() -> void:
	_active = false

func attack_received(_attack: Attack) -> void:
	pass


func _on_aggro_radius_body_entered(body: Node2D) -> void:
	if !_active:
		return
		
	state_manager.active_state = Chase_state
