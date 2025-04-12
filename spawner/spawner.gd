class_name Spawner extends Node2D

@onready var timer: Timer = $"timer"

@export_group("Settings")
@export var enable:bool = true
## will the enemies respawn on death
@export var respawn:bool = false
## how many enemies for the spawner will be on screen at a time
@export var total_spawns: int = 1
## will spawn the firs on ready and then one enemy with this interval
@export var time_between_spawns: float = 5.0
## what scene will be spawned Will need to extend the Enemy class
@export var spawing: PackedScene
@export var effect_scene: PackedScene

var _enemies: Array
var _enemies_spawned_count: int = 0

func _start() -> void:
	_spawn()
	timer.start()
	Game.Reset.connect(reset)

func _ready() -> void:
	# set timer wait time variable to same as timer inspector variable
	timer.wait_time = time_between_spawns 
	_start()
	

func _spawn() -> void: # need to use global position as offset otherwise all spawners spawn around
	if !enable:
		return
	if _enemies_spawned_count >= total_spawns:
		timer.stop()
	else:
		if effect_scene != null:
			var effect:Node2D = effect_scene.instantiate()
			effect.position = position
			$"..".add_child(effect)
			
		var spawnd:Enemy = spawing.instantiate()
		
		spawnd.position = position
		spawnd.Died.connect(_enemy_dies)
		_enemies.append(spawnd)
		_enemies_spawned_count += 1
		
		$"..".add_child(spawnd)
		timer.start()

func _enemy_dies() -> void:
	if !respawn:
		return
		
	_enemies_spawned_count -= 1
	
func reset() -> void:
	for enemy:Enemy in _enemies:
		enemy.queue_free()
		
	timer.stop()
	_start()


func _on_timer_timeout() -> void:
	_spawn()
