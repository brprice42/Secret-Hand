extends Control


var winner: bool:
	set(value):
		if value == true:
			$ColorRect2/Outcome.text = "You Win!!!"
			$ColorRect2/Outcome.add_theme_color_override("font_color", Color("2767ab"))
			$ColorRect2/Outcome.add_theme_color_override("font_shadow_color", Color("051d37"))
		else:
			$ColorRect2/Outcome.text = "You Lose"
			$ColorRect2/Outcome.add_theme_color_override("font_color", Color("ff3629"))
			$ColorRect2/Outcome.add_theme_color_override("font_shadow_color", Color("380000"))
		$ColorRect2/EnemyText.text = "Loss Count:  " + str(Globals.lossCount)
		$ColorRect2/PlayerText.text = "Win Count:  " + str(Globals.winCount)
	
	
