extends Node

var enabled := false:
	set(value):
		enabled = value

var bus: int

func _ready() -> void:
	bus = AudioServer.get_bus_index("Music")

func _process(_delta: float) -> void:
	if not enabled:
		return
	
	# ImGui.Begin("Debug Tools")
	# var show_collision_shapes = [show_debug_collisions_hint]
	# ImGui.Checkbox("Show collision shapes", show_collision_shapes)
	# 
	# var music_volume = [db_to_linear(AudioServer.get_bus_volume_db(bus))]
	# ImGui.SliderFloat("Music Volume", music_volume, 0.0, 2.0)
	# AudioServer.set_bus_volume_db(bus, linear_to_db(music_volume[0]))
	# 
	# var music_muted = [not AudioServer.is_bus_mute(bus)]
	# ImGui.Checkbox("Enable music", music_muted)
	# AudioServer.set_bus_mute(bus, not music_muted[0])
	# 
	# if ImGui.Button("Respawn"):
	# 	Game.get_player().global_position = Game.get_player().respawn_point
	# 
	# if show_collision_shapes[0] != show_debug_collisions_hint:
	# 	show_debug_collisions_hint = show_collision_shapes[0]
	# 
	# ImGui.End()

# Original function created by raldone01 - https://github.com/godotengine/godot-proposals/issues/2072#issuecomment-1890114615
var show_debug_collisions_hint: bool:
	set(visible):
		var tree: SceneTree = get_tree()
		# https://github.com/godotengine/godot-proposals/issues/2072
		tree.debug_collisions_hint = visible

		# Traverse tree to call toggle collision visibility
		var node_stack: Array[Node] = [tree.get_root()]
		while not node_stack.is_empty():
			var node: Node = node_stack.pop_back()
			if is_instance_valid(node):
				if node is CollisionShape2D or node is CollisionPolygon2D or node is CollisionObject2D:
					# queue_redraw on instances of
					node.queue_redraw()
				elif node is TileMap:
					# use visibility mode to force redraw
					node.collision_visibility_mode = TileMap.VISIBILITY_MODE_FORCE_HIDE
					node.collision_visibility_mode = TileMap.VISIBILITY_MODE_DEFAULT
				node_stack.append_array(node.get_children())
	get:
		return get_tree().debug_collisions_hint
