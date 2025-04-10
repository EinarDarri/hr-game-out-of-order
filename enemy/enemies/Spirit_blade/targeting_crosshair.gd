extends Sprite2D

@export var enemy: Enemy

## Whenever queue_redraw is called, the line is updated to reflect the change in the marker's position.
func _draw() -> void:
	draw_dashed_line(Vector2.ZERO, to_local(enemy.global_position), Color.RED, 1)
