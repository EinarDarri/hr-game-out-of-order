extends Sprite2D

@export var enemy: Enemy

func _draw() -> void:
	draw_dashed_line(enemy.global_position, global_position, Color.RED, 1)
