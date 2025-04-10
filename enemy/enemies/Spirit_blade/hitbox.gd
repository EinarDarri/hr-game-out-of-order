extends Area2D

@export var enemy: Enemy
@export var contact_damage: int
@export var knockback_amount: float
@export var damage_cooldown: float

@onready var damage_timer: Timer = $DamageTimer

var _can_damage: bool = true

func _ready() -> void:
	damage_timer.timeout.connect(func(): _can_damage = true)

func _on_body_entered(body: Player) -> void:
	if !_can_damage:
		return

	var atk := Attack.new()
	atk.damage = contact_damage
	atk.knockback = enemy.global_position.direction_to(body.global_position) * knockback_amount
	body.take_damage(atk)
	_can_damage = false
	damage_timer.start(damage_cooldown)
