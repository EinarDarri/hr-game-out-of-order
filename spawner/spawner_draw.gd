@tool
class_name SpawnerDrawer extends Node2D

var spawner: Spawner
func _draw() -> void:
	if Engine.is_editor_hint():
		if spawner == null:
			spawner = get_parent()
			
		set_z_index(4096)
			
		var topline: Array[Vector2] = [Vector2(spawner.LIMIT_LEFT, spawner.LIMIT_TOP), Vector2(spawner.LIMIT_RIGHT, spawner.LIMIT_TOP)]
		var leftline: Array[Vector2] = [Vector2(spawner.LIMIT_LEFT, spawner.LIMIT_TOP), Vector2(spawner.LIMIT_LEFT, spawner.LIMIT_BOTTOM)]
		var rightline: Array[Vector2] = [Vector2(spawner.LIMIT_RIGHT, spawner.LIMIT_TOP), Vector2(spawner.LIMIT_RIGHT, spawner.LIMIT_BOTTOM)]
		var bottomline: Array[Vector2] = [Vector2(spawner.LIMIT_LEFT, spawner.LIMIT_BOTTOM), Vector2(spawner.LIMIT_RIGHT, spawner.LIMIT_BOTTOM)]

		var col:Color = Color(0,255,255)
		var width: int = 5
		draw_line(topline[0], topline[1],col,width)
		draw_line(leftline[0], leftline[1],col,width)
		draw_line(rightline[0], rightline[1],col,width)
		draw_line(bottomline[0], bottomline[1],col,width)
