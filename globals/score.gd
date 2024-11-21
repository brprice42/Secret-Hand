extends Node


func flush(cards: Array) -> bool:
	var matching = cards.filter(func(card): return card.suit == cards[0].suit)
	return matching.size() == 5
		
func straight(cards: Array) -> bool:
	var previous: int = cards[0].value - 1
	
	var royalStraight
	if(cards[0].value == 1):
		royalStraight = check_ace(cards)
		
	if royalStraight:
		return true
		
	for i in range(cards.size()):
		if cards[i].value != previous + 1:
			return false
		previous += 1
	return true
	
#func fourOfKind(cards: Array) -> bool:
	#if cards.filter(func(card): return card.value == cards[2].value).size() == 4:
		#return true
	#else:
		#return false
	
func threeOfKind(cards: Array) -> bool:
	if cards.filter(func(card): return card.value == cards[2].value).size() >= 3:
		return true
	else:
		return false
		
func fullHouse(cards: Array) -> bool:
	if threeOfKind(cards):
		if cards[0].value == cards[1].value and cards[3].value == cards[4].value:
			return true
			
	return false
	
func twoPair(cards: Array) -> bool:
	if !threeOfKind(cards):
		if cards[0].value == cards[1].value and cards[2].value == cards[3].value:
			return true
		if cards[0].value == cards[1].value and cards[3].value == cards[4].value:
			return true
		if cards[2].value == cards[1].value and cards[3].value == cards[4].value:
			return true
	return false
	
	
func check_ace(cards: Array) -> bool:
	if cards[0].value == 1 and cards[1].value == 10 and cards[2].value == 11 and cards[3].value == 12 and cards[4].value == 13:
		return true
	else:
		return false;
		
func is_secret_hand(cards) -> bool:
	if Globals.flipSuit == Globals.DIAMONDS:
		return straight(cards)
	elif Globals.flipSuit == Globals.CLUBS:
		return fullHouse(cards)
	elif Globals.flipSuit == Globals.HEARTS:
		return flush(cards)
	else:
		for card in cards:
			if card.value == Globals.flipValue:
				return true
		return false
			
		
		
func score(cards) -> int:
	if is_secret_hand(cards):
		return 15
		
	var score: int = Globals.flipNumber
	if threeOfKind(cards):
		score += 3
	if twoPair(cards):
		score += 2
	
	return score
	
func enemyAI(hand: Array) -> Array:
	var best_score = 0
	var best_hand: Array = [0, 1, 2, 3, 4]
	for i in range(hand.size() - 4):
		for j in range(i + 1, hand.size() - 3):
			for k in range(j + 1, hand.size() - 2):
				for l in range(k + 1, hand.size()-1):
					for m in range(l + 1, hand.size()):
						var score = score([hand[i], hand[j], hand[k], hand[l], hand[m]])
						if  score > best_score:
							best_hand = [i, j, k, l, m]
							best_score = score
							
	hand[best_hand[0]].cardSelected = true
	hand[best_hand[1]].cardSelected = true
	hand[best_hand[2]].cardSelected = true
	hand[best_hand[3]].cardSelected = true
	hand[best_hand[4]].cardSelected = true
	
	return [hand[best_hand[0]], hand[best_hand[1]], hand[best_hand[2]], hand[best_hand[3]], hand[best_hand[4]]]
		
	
