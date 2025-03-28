@tool
class_name Spawner extends Node2D

@onready var drawing: SpawnerDrawer = $"Draw stuff"
@onready var timer: Timer = $"timer"

@export var enable:bool = true
@export var spawing: PackedScene
@export var time_between_spawns: float = 5.0
@export var total_spawns: int = 3
var count_spawns: int = 0

@export_group("Spawn box")
@export var LIMIT_LEFT:int = -250:
	set(value):
		LIMIT_LEFT = value
		queue_redraw()
@export var LIMIT_TOP:int = -250:
	set(value):
		LIMIT_TOP = value
		queue_redraw()
@export var LIMIT_RIGHT:int = 250:
	set(value):
		LIMIT_RIGHT = value
		queue_redraw()
@export var LIMIT_BOTTOM:int = 250:
	set(value):
		LIMIT_BOTTOM = value
		queue_redraw()
		
		
func _ready() -> void:
	if drawing == null:
		_make_drawing_object()
	# set timer wait time variable to same as timer inspector variable
	timer.wait_time = time_between_spawns 
	timer.start()

func _make_drawing_object() -> void:
	drawing = SpawnerDrawer.new()
	add_child(drawing)
	drawing.set_owner(self)
	drawing.name = "Draw stuff"
	return
	
func get_random_cords() -> Vector2:
	var x = randf_range(LIMIT_LEFT, LIMIT_RIGHT)
	var y = randf_range(LIMIT_TOP, LIMIT_BOTTOM)
	return Vector2(x,y)
	
func _spawn() -> void: # need to use global position as offset otherwise all spawners spawn around
	if count_spawns >= total_spawns:
		timer.stop()
	else:
		var pos:Vector2 = get_random_cords() + global_position
		var spawnd:= spawing.instantiate()
	
		spawnd.position = pos
		count_spawns+=1
	
		$"..".add_child(spawnd)
		timer.start()
	
func _draw() -> void:
	if Engine.is_editor_hint():
		if drawing == null:
			_make_drawing_object()

		drawing.queue_redraw()


func _on_timer_timeout() -> void:
	_spawn()
