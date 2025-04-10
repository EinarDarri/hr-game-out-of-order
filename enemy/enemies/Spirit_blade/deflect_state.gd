extends EnemyState

@export var deflect_speed: float = 10.0
@export var chase_state: EnemyState
## The collision layer at which the tilemap resides.
@export var world_collision_layer: int
@export var reaggro_delay: float
@export var damage_on_collision: int

@onready var reaggro_delay_timer: Timer = $ReaggroDelayTimer

var _start_pos: Vector2
var _dir: Vector2
var _coll_before: int
var _mask_before: int
var _active: bool

func _ready() -> void:
	_coll_before = enemy.collision_layer
	_mask_before = enemy.collision_mask
	reaggro_delay_timer.timeout.connect(func(): state_manager.active_state = chase_state)

func start_state() -> void:
	_start_pos = enemy.global_position
	enemy.collision_layer |= world_collision_layer
	enemy.collision_mask |= world_collision_layer
	_dir = enemy.get_last_attack_received().knockback.normalized()
	enemy.velocity = _dir * deflect_speed
	_active = true

func physics_update(delta: float) -> void:
	if !_active:
		return

	var coll := enemy.get_last_slide_collision()
	if coll != null:
		enemy.velocity = Vector2.ZERO
		_active = false
		reaggro_delay_timer.start(reaggro_delay)
		var atk := Attack.new()
		atk.damage = damage_on_collision
		enemy.take_damage(atk)
	else:
		enemy.velocity = Vector2(
			move_toward(enemy.velocity.x, 0, ( absf(_dir.x) * deflect_speed * delta) / 2),
			move_toward(enemy.velocity.y, 0, ( absf(_dir.y) * deflect_speed * delta) / 2)
		)
		if enemy.global_position.distance_to(_start_pos) >= deflect_speed:
			_active = false
			reaggro_delay_timer.start(reaggro_delay)

func end_state() -> void:
	enemy.collision_layer = _coll_before
	enemy.collision_mask = _mask_before
