extends Control

var hintPages: Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hintPages = $HintScreen.get_children()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_spade_pressed() -> void:
	hide_hints()
	$HintScreen.show()
	$HintScreen/CardHint.show()


func _on_diamond_pressed() -> void:
	hide_hints()
	$HintScreen.show()


func _on_heart_pressed() -> void:
	hide_hints()
	$HintScreen.show()


func _on_club_pressed() -> void:
	hide_hints()
	$HintScreen.show()
	$HintScreen/CoasterHint.show()

func _input(event):
	if event is InputEventKey:
		if event.keycode == KEY_ESCAPE:
			hide_hints()


func _on_hint_screen_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			hide_hints()
			
			
func hide_hints():
	for hint in hintPages:
		hint.hide()
	$HintScreen.hide()
			
	
