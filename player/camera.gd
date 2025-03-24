extends Camera2D

@onready var player: Player = $".."

@export var extra_speed:int = 500

const MAX_POS = 150
const MAX_SPEED = 100

func _process(delta: float) -> void:
	var mvdir := player.get_movement_dir()
		
	var to := mvdir * extra_speed
	
	const LERP_WEIGHT = 5
	var pos := Vector2(
		clampf(lerpf(position.x,to.x,LERP_WEIGHT),-MAX_SPEED,MAX_SPEED),
		clampf(lerpf(position.y,to.y,LERP_WEIGHT),-MAX_SPEED,MAX_SPEED)
	) * delta

	position = Vector2(
		clampf(position.x + pos.x,-MAX_POS,MAX_POS),
		clampf(position.y + pos.y,-MAX_POS,MAX_POS)
	)
	
