class_name Enemy extends Area2D

@export var movement_speed: float = 10.0
@export var max_health: int = 100
@export var take_damage_particle: PackedScene
@export var death_effect_scene: PackedScene

var _health: int
var _target_velocity: Vector2
var _can_attack: bool = true

signal attack_received(attack: Attack)

func _ready() -> void:
	_health = max_health
