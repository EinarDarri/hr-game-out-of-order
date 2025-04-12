extends Node

## Resets the level and enemies / spawners
signal Reset

var LightMode:bool = false

var _player: Player

func set_player(player: Player) -> void:
	_player = player

func get_player() -> Player:
	return _player
