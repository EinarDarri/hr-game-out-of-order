extends Area2D

@export var dialog_name: String
@export var one_time:bool = true

func _ready() -> void:
	body_entered.connect(play)
	
func play(body:Node2D) -> void:
	if body is Player:
		Dialogic.start(dialog_name)
		
		if one_time:
			queue_free()
			
	
