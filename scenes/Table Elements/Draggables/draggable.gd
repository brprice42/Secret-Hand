extends Area2D

signal draggable_clicked
#Adapted from bytemyke source code for https://www.youtube.com/watch?v=neZ9tLVUDk4&feature=youtu.be
var contains_mouse: bool = false

var is_dragging = false

var mouse_offset #center mouse on click
var delay = .2
func _physics_process(delta):
	if is_dragging == true:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", get_global_mouse_position()-mouse_offset, delay * delta)
		
func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int):
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			mouse_offset = get_global_mouse_position()-global_position
			draggable_clicked.emit()
		else:
			if is_dragging:
				is_dragging = false


func _on_mouse_entered() -> void:
	contains_mouse = true

func _on_mouse_exited() -> void:
	contains_mouse = false
