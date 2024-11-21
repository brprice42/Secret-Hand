extends Node

enum {CLUBS, DIAMONDS, HEARTS, SPADES}
signal handReady(isReady: bool)

var flipSuit: int = 0

var flipNumber: int = 0

var flipValue: int = 0

var winCount: int = 0

var lossCount: int = 0

var gameOver: bool = false

var isWinner: bool = false

var maxSelected = false
var selected: int = 0:
	set(value):
		selected = value
		if value >= 5:
			maxSelected = true
			handReady.emit(maxSelected)
		else:
			maxSelected = false
			handReady.emit(maxSelected)




# Called when the node enters the scene tree for the first time.
var test = "hello"
