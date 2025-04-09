extends AnimatedSprite2D

@onready var point_light_2d: PointLight2D = $PointLight2D

func _ready() -> void:
	point_light_2d.shadow_enabled = true
	play()
