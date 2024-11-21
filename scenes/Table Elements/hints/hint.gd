extends Area2D

class_name Hint


var hint_type: String = "default"

signal hint_clicked(type: String)

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		hint_clicked.emit(hint_type)
