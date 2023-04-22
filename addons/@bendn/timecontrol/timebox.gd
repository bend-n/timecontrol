extends HBoxContainer
class_name TimeBox

var time := {
	"hour": 12,
	"minute": 00,
}

func _changed():
	time_changed.emit()

signal time_changed(time: Dictionary)

func _on_hour_selection_changed(hour: int) -> void:
	time.hour = hour
	_changed()

func _on_minute_selection_changed(minute: int) -> void:
	time.minute = minute
	_changed()

func fmt_24h() -> String:
	return TimeBox.fmt_dict_24h(time)

func fmt_12h() -> String:
	return TimeBox.fmt_dict_12h(time)

static func fmt_dict_12h(dict: Dictionary) -> String:
	return "%02d:%02d %s" % [
		(dict.hour + 11) % 12 + 1,
		dict.minute,
		"PM" if dict.hour >= 12 else "AM"
	]

static func fmt_dict_24h(dict: Dictionary) -> String:
	return "%02d:%02d" % [dict.hour, dict.minute]
