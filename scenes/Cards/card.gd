extends Container

var suit: int
var value: int
var number: int

var isEnemy: bool:
	set(enemy):
		if enemy:
			$Graphic/Back.show()
			isEnemy = enemy
		
		

var card: Vector2i:
	set(cardValue):
		card = cardValue
		suit = card.x
		value = card.y
		number = min(card.y, 10)
		
		
		var filepath: String = "res://Github-Game-Off/graphics/cards/PaperCards1.1/"
		var suitName: String = ""

		match suit:
			Globals.CLUBS:
				suitName = "Clubs"
			Globals.DIAMONDS:
				suitName = "Dmnds"
			Globals.HEARTS:
				suitName = "Hearts"
			Globals.SPADES:
				suitName = "Spades"

		filepath += suitName + "/"
		
		match value:
			1:
				filepath += "Aof" + suitName + ".png"
			11:
				filepath += "Jof" + suitName + ".png"
			12:
				filepath += "Qof" + suitName + ".png"
			13:
				filepath += "Kof" + suitName + ".png"
			_:
				filepath += str(value) + "of" + suitName + ".png"
				

		$Graphic/Face.texture = load(filepath)

var cardHighlighted: bool = false
var cardSelected: bool = false

func show_face():
	$Graphic/Back.hide()

func _on_mouse_entered() -> void:
	if not isEnemy:
		if not cardSelected and not Globals.maxSelected:
			$AnimationPlayer.play("select")
			cardHighlighted = true


func _on_mouse_exited() -> void:
	if not isEnemy:
		if not cardSelected and cardHighlighted:
			$AnimationPlayer.play("deselect")
			cardHighlighted = false

	
func move(pos: Vector2):
	var tween = get_tree().create_tween()
	#$Graphic.hide()
	tween.tween_property($".", "global_position", pos, .5)

	
func _on_gui_input(event: InputEvent) -> void:
	
	if (event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT and not isEnemy):
		if cardSelected:
			$AnimationPlayer.play("deselect")
			cardHighlighted = false
			cardSelected = false
			Globals.selected -= 1
		else:
			if not Globals.maxSelected:
				Globals.selected += 1
				cardSelected = true
				if not cardHighlighted:
					$AnimationPlayer.play("select")
					cardHighlighted = true
			
			
			
			
