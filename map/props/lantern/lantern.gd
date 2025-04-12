@tool
extends AnimatedSprite2D

@onready var point_light_2d: PointLight2D = $PointLight2D

@export var light_color: Color

func _ready() -> void:
	if not Engine.is_editor_hint():
		point_light_2d.shadow_enabled = true
		play()

func _process(delta: float) -> void:
	point_light_2d.color = light_color
