@tool
class_name HealthBar extends ProgressBar

@onready var label: Label = $Label

@export var target: Node:
	set(value):
		target = value
		update_configuration_warnings()

@export var show_number: bool = true:
	set(value):
		show_number = value
		update_number_visibility()

func _ready() -> void:
	update_configuration_warnings()
	
	if not Engine.is_editor_hint() and target != null and target.has_method("get_max_health"):
		max_value = target.get_max_health()

func _process(delta: float) -> void:
	if Engine.is_editor_hint() || target == null || not target.has_method("get_health"):
		return
	
	value = target.get_health()
	label.text = "%d" % target.get_health()

func _get_configuration_warnings() -> PackedStringArray:
	var warnings = PackedStringArray()
	
	if target == null:
		warnings.push_back("Target is null.")
	
	if target == null or not target.has_method("get_health"):
		warnings.push_back("Target does not contain 'get_health' method.")
	
	if target == null or not target.has_method("get_max_health"):
		warnings.push_back("Target does not contain 'get_max_health' method.")
	
	return warnings

func update_number_visibility():
	$Label.visible = show_number
