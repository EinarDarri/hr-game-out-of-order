extends EnemyState

@export var attack_delay: float
@export var reaggro_delay: float
@export var damage: int
@export var knockback_amount: float
@export var attack_area: Area2D
@export var aggro_state: EnemyState
@export var sprite: AnimatedSprite2D

@onready var attack_delay_timer: Timer = $AttackDelayTimer
@onready var reaggro_delay_timer: Timer = $ReaggroDelayTimer

var _can_damage: bool

func _ready() -> void:
	attack_delay_timer.timeout.connect(_attack)
	reaggro_delay_timer.timeout.connect(func(): state_manager.active_state = aggro_state)

func start_state() -> void:
	_can_damage = true
	enemy.velocity = Vector2.ZERO
	sprite.play("attack")
	attack_delay_timer.start(attack_delay)

func _attack() -> void:
	if not _can_damage:
		return
	_can_damage = false
	for body: Player in attack_area.get_overlapping_bodies():
		var atk := Attack.new()
		atk.damage = damage
		atk.knockback = enemy.global_position.direction_to(Game.get_player().global_position) * knockback_amount
		body.take_damage(atk)
	reaggro_delay_timer.start(reaggro_delay)
