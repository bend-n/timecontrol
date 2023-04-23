@tool
extends Button
class_name TimeButton

@export var time := {
	"hour": 12,
	"minute": 00,
}: set = set_time

var timebox: TimeBox
var panel: PopupPanel

signal time_changed(time: Dictionary)

func set_time(t: Dictionary = time) -> void:
	time = t
	text = TimeBox.fmt_dict_12h(time)
	time_changed.emit(time)

func _ready() -> void:
	text = TimeBox.fmt_dict_12h(time)
	if Engine.is_editor_hint():
		return
	panel = PopupPanel.new()
	timebox = preload("./timebox.tscn").instantiate()
	timebox.time = time
	timebox.time_changed.connect(set_time)
	panel.add_child(timebox)
	add_child(panel)
	panel.hide()

func _pressed() -> void:
	panel.size = Vector2()
	panel.position = global_position
	panel.popup()
