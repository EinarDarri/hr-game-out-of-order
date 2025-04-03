class_name SfxOneOff extends AudioStreamPlayer

func _init(sfx: AudioStream, db: float = 0.0) -> void:
	stream = sfx
	volume_db = db

func _ready() -> void:
	play()
	finished.connect(queue_free)
