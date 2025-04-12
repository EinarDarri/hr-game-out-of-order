extends Node2D

@export var take_damage_particle: PackedScene
@onready var spirit_blade: Enemy = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_spirit_blade_attack_received(attack: Attack) -> void:
	if spirit_blade.get_health() == 0:
		pass
	else:
		var strike := take_damage_particle.instantiate()
		add_child(strike)
		strike.emitting = true # manually turn on emitting since blood is a oneshot.
