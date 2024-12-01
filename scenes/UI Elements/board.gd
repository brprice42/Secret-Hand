extends Node2D

@onready var p1pins = $Player1.get_children()
@onready var p2pins = $Player2.get_children()


@export var emptyColor: Color
@export var player1Color: Color
@export var player2Color: Color

var player1: int = 0:
	set(value):
		value = min(value, 86)
		p1pins[player1].modulate = emptyColor
		p1pins[player1].scale = Vector2(.25,.25)
		p1pins[value].modulate = player1Color
		p1pins[value].scale = Vector2(.3,.3)
		player1 = value
		if value == 86:
			Globals.isWinner = true
			Globals.winCount += 1
			Globals.gameOver = true
		
var player2: int = 0:
	set(value):
		value = min(value, 86)
		p2pins[player2].modulate = emptyColor
		p2pins[player2].scale = Vector2(.25,.25)
		p2pins[value].modulate = player2Color
		p2pins[value].scale = Vector2(.3,.3)
		player2 = value
		if value == 86:
			Globals.isWinner = false
			Globals.lossCount += 1
			Globals.gameOver = true
		
func _ready() -> void:
	for pin in p1pins + p2pins:
		pin.modulate = emptyColor
	player1 = 0
	player2 = 0
