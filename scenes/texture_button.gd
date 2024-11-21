extends TextureButton


func _ready() -> void:
	Globals.connect("handReady", update_button)
	
func update_button(isReady: bool):
	disabled = !isReady
	
	
