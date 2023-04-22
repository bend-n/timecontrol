@tool
extends VBoxContainer
class_name Scroll

@export var label_color: Color = Color("#eee8d5")
@export var label_color_unselected: Color = Color("#93a1a1")
@export var lookahead := 1:
	set(lok):
		if lookahead != lok:
			lookahead = lok
			make_children()

@onready var items: Array[String] = make_items()

signal selection_changed(item: int)
var children: Array[Label]

@export var selection: int:
	set(sel):
		if selection != sel:
			selection = sel
			make_children()
			selection_changed.emit(selection)

func make_children():
	if not is_inside_tree():
		return
	for child in children:
		child.queue_free()
	children.clear()
	for n in range(lookahead, 0, -1):
		make_label(items[selection + -n])
	make_label(items[selection], true)
	for n in lookahead:
		make_label(items[wrapi(selection + n + 1, 0, len(items))])

func _ready() -> void:
	make_children()
	var font := get_theme_default_font()
	for item in items:
		var string_size := font.get_string_size(item).x
		if custom_minimum_size.x < string_size:
			custom_minimum_size.x = string_size

## overridable
func make_label(text: String, selected: bool = false) -> void:
	var label := Label.new()
	label.text = text
	label.name = text
	label.add_theme_color_override("font_color", label_color if selected else label_color_unselected)
	add_child(label)
	children.append(label)

## virtual
func make_items() -> Array[String]:
	return []

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		match event.button_index:
			MOUSE_BUTTON_WHEEL_UP: selection = wrapi(selection - 1, 0, len(items))
			MOUSE_BUTTON_WHEEL_DOWN: selection = wrapi(selection + 1, 0, len(items))
