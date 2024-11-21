extends Control

signal close


func _on_texture_button_pressed() -> void:
	
	for card in $ScoringCards.get_children():
		card.queue_free()
	close.emit()
