extends Node2D

## Handles rotation based on the input mapping and input state.
func _physics_process(_delta: float) -> void:
	return
	var dir := Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		dir = dir.direction_to(Vector2.LEFT)
	if Input.is_action_pressed("move_right"):
		dir = dir.direction_to(Vector2.RIGHT)
	if Input.is_action_pressed("look_up"):
		dir = Vector2.UP
	if Input.is_action_pressed("look_down"):
		dir = Vector2.DOWN
	
	rotation = atan2(dir.y, dir.x)
