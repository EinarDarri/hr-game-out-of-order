extends PlayerState

var perf_state: PlayerState
var player_velocity: Vector2 

func start_state() -> void:
	player_velocity = player.velocity

func update_state(delta: float) -> void:
	pass
	
func end_state() -> void:
	player.velocity = player_velocity
