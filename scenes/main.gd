extends Node2D

var Card = preload("res://Github-Game-Off/scenes/Cards/card.tscn")

const HAND_SIZE: int = 9
var PlayerHand: Array = Array()
var EnemyHand: Array = Array()
var PlayerScoringHand: Array = Array()
var EnemyScoringHand: Array = Array()
var FlipCard

var Deck: Array
var Discard: Array
var draggables: Array

@onready var playerPositions = $cardLocations/PlayerHandPosition.get_children().map(func(x): return x.global_position)
@onready var enemyPositions = $cardLocations/EnemyHandPosition.get_children().map(func(x): return x.global_position)
@onready var playerScoringPositions = $cardLocations/PlayerScoringPosition.get_children().map(func(x): return x.global_position)
@onready var enemyScoringPositions = $cardLocations/EnemyScoringPosition.get_children().map(func(x): return x.global_position)

func _ready() -> void:
	
	
	$Blues.play()
	draggables = get_tree().get_nodes_in_group("draggable")
	for item in draggables:
		item.connect("draggable_clicked", _on_draggable_clicked)
		
	for item in get_tree().get_nodes_in_group("hints"):
		item.connect("hint_clicked", _on_hint_clicked)

	Discard = Array()
	setDeck()


	
#world interaction
func _on_draggable_clicked():
	var found: bool = false
	var items = $Draggables.get_children()
	items.reverse()
	for item in items:
		if not found:
			if item.contains_mouse:
				item.is_dragging = true
				found = true
		else:
			item.is_dragging = false

func _on_hint_clicked(type: String):
	var found: bool = false
	if type == "book":
		$hintSFX.play()
		$UI/Diamond.show()
		$Draggables/Book/BookHint.hide()
	var items = $Draggables.get_children()
	items.reverse()
	for item in items:
		if item.contains_mouse:
			return
	$hintSFX.play()
	if type == "coaster":
		$UI/Club.show()
		$Hints/CoasterHint.hide()
	if type == "card":
		$UI/Spade.show()
		$Hints/CardHint.hide()
	if type == "letter":
		$UI/Heart.show()
		$Hints/LetterHint.hide()
	if type == "book":
		$UI/Diamond.show()


#Deck functions
func setDeck():
	Deck = Array()
	for i in range(4):
		for j in range(1, 14):
			Deck.append(Vector2i(i, j))
			
	Deck.shuffle()

func resetDeck():
	Deck = Discard
	Discard = Array()
	Deck.shuffle()

func draw():
	if Deck.size() > 0:
		return Deck.pop_back()
	else:
		resetDeck()
		return Deck.pop_back()
	print(Deck.size())

func orderCards(a, b):
	if a.card.y < b.card.y:
		return true
	elif a.card.y == b.card.y:
		return a.card.x < b.card.x
	else:
		return false

func flip_card():
	FlipCard = Card.instantiate()
	FlipCard.card = draw()
	FlipCard.isEnemy = true
	FlipCard.show_face()
	%Spawn.add_child(FlipCard)
	Globals.flipSuit = FlipCard.suit
	Globals.flipNumber = FlipCard.number
	Globals.flipValue = FlipCard.value

func dealEnemy():
	for i in range(HAND_SIZE - $Hands/EnemyHand.get_child_count()):
		var instance = Card.instantiate()
		instance.global_position = %Spawn.position
		instance.card = draw()
		instance.isEnemy = true
		$Hands/EnemyHand.add_child(instance)
		
	EnemyHand = $Hands/EnemyHand.get_children()
	EnemyHand.sort_custom(orderCards)
	for i in range(EnemyHand.size()):
		EnemyHand[i].move(enemyPositions[i])

func dealPlayer():
	$PlayHandButton.show()
	$DealCards.play()
	for i in range(HAND_SIZE - $Hands/PlayerHand.get_child_count()):
		var instance = Card.instantiate()
		instance.global_position = %Spawn.position
		instance.card = draw()
		$Hands/PlayerHand.add_child(instance)
		
	PlayerHand = $Hands/PlayerHand.get_children()
	PlayerHand.sort_custom(orderCards)
	for i in range(PlayerHand.size()):
		PlayerHand[i].move(playerPositions[i])

func _on_play_hand_button_pressed() -> void:
	play_hand()
	clear_cards()
	
func clear_cards():

	Globals.selected = 0
		

	PlayerScoringHand = Array()
	EnemyScoringHand = Array()
	
func play_hand():
	$PlayHandButton.hide()
	$PlayHand.play()
	for i in range(PlayerHand.size()):
		if PlayerHand[i].cardSelected:
			PlayerScoringHand.append(PlayerHand[i])
			
	EnemyScoringHand = Score.enemyAI(EnemyHand)
	
	var enemyScore = Score.score(EnemyScoringHand)
	var playerScore = Score.score(PlayerScoringHand)
	
	for card in EnemyScoringHand:
		Discard.append(card.card)
		$Hands/EnemyHand.remove_child(card)
		$ScoreScreen/ScoringCards.add_child(card)
		card.show_face()
		
	for card in PlayerScoringHand:
		Discard.append(card.card)
		$Hands/PlayerHand.remove_child(card)
		$ScoreScreen/ScoringCards.add_child(card)
	
	Discard.append(FlipCard.card)
	%Spawn.remove_child(FlipCard)
	FlipCard.global_position = %Spawn.position
	$ScoreScreen/ScoringCards.add_child(FlipCard)
		
	if playerScore > enemyScore:
		$ScoreScreen/ColorRect2/PlayerText.text = "Winner  +" + str(playerScore)
		$ScoreScreen/ColorRect2/EnemyText.text = "Loser"
		%Board.player1 += playerScore
	elif playerScore < enemyScore:
		$ScoreScreen/ColorRect2/PlayerText.text = "Loser"
		$ScoreScreen/ColorRect2/EnemyText.text = "Winner  +" + str(enemyScore)
		%Board.player2 += enemyScore
	else:
		$ScoreScreen/ColorRect2/PlayerText.text = "Draw"
		$ScoreScreen/ColorRect2/EnemyText.text = "Draw"
		
	$ScoreScreen.show()
	
	for i in range(PlayerScoringHand.size()):
		PlayerScoringHand[i].move(playerScoringPositions[i])
		
	for i in range(EnemyScoringHand.size()):
		EnemyScoringHand[i].move(enemyScoringPositions[i])

func clear_game():
	setDeck()
	Discard = Array()
	
	for card in $ScoreScreen/ScoringCards.get_children():
		card.queue_free()
		
	for card in $Hands/PlayerHand.get_children():
		card.queue_free()
		
	for card in $Hands/EnemyHand.get_children():
		card.queue_free()

func start_game():
	
	%Board.player1 = 0
	%Board.player2 = 0
	dealEnemy()
	dealPlayer()
	flip_card()

func _on_score_screen_close() -> void:
	$ScoreScreen.hide()
	if !Globals.gameOver:
		dealEnemy()
		dealPlayer()
		flip_card()
	else:
		clear_game()
		$GameOverScreen.winner = Globals.isWinner
		
		$Blues.volume_db = 0
		$Soft.stop()
		$Blues.play()
		
		$GameOverScreen.show()
		Globals.gameOver = false

func _on_new_game_pressed() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($Blues, "volume_db", -10, .5)
	tween.parallel().tween_property($GameOverScreen, "modulate", Color.TRANSPARENT, .5)
	
	await tween.finished
	$Blues.stop()
	$Soft.play()

	
	$GameOverScreen.hide()
	$GameOverScreen.modulate = Color.WHITE
	start_game()

func _on_diologue_finish_scene() -> void:
	start_game()

func _on_start_game_pressed() -> void:
	
	var tween = get_tree().create_tween()
	tween.tween_property($Blues, "volume_db", -10, .5)
	tween.parallel().tween_property($StartScreen, "modulate", Color.TRANSPARENT, .5)
	
	await tween.finished
	$Blues.stop()
	$Soft.play()

	$StartScreen.hide()
	$Diologue.queue_text("you", "* knock * * knock * Hello? Grandpa? I'm here!")
	$Diologue.queue_text("grampa", "Is that you? Oh, welcome in. Geez, how long has it been?")
	$Diologue.queue_text("you", "It's been a while for sure, I'm just glad I could make it out.")
	$Diologue.queue_text("grampa", "Say, now that you're here, we ought to play some cards.")
	$Diologue.queue_text("grampa", "Do you remember how to play Secret Hand?")
	$Diologue.queue_text("you", "Uhh. I'm not su--")
	$Diologue.queue_text("grampa", "Oh who am I kidding. No blood of mine would forget the rules of Secret Hand.")
	$Diologue.queue_text("you", "Umm.. Yeah, you're going down!")
	$Diologue.queue_text("grampa", "Go shuffle the cards while I make you a coffee then.")
	$Diologue.queue_text("grampa", "(he heh... the cocky brat hasn't come around in years and thinks he can beat me.)")
	$Diologue.queue_text("you", "(Secret Hand? I might have played it before but I don't remember the rules.)")
	$Diologue.queue_text("you", "(There may be clues written down somewhere. I doubt he knows the rules by heart.)")
	$Diologue.queue_text("grampa", "Ok, lets get this game going. Deal em' out!")
