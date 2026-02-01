extends Node2D

var g = globals
var dev = globals.dev_mode

var opponent_decision_chances = [0.9,0.9,0.9,0.9,0.8,0.8,0.8,0.7,0.7,0.7,0.6,0.6,0.5,0.5,0.4,0.4,0.2,0.2,0.1,0.1]

signal update_game()
signal dev_mode_enabled()
signal set_score(player_value, opponent_value)

var card_value = 0

func _ready() -> void:
	get_node("Winner").set("visible", false)
	get_node("Winner/PlayerWin").set("visible", false)
	get_node("Winner/OpponentWin").set("visible", false)

func deal_card() -> int:
	return (randi() % 10 + 1)

func initial_deal_player() -> void:
	card_value = deal_card()
	g.player_cards[0] = card_value
	g.player_dealt_amount += 1
	card_value = deal_card()
	g.player_cards[1] = card_value
	g.player_dealt_amount += 1
	update_game.emit()
	get_node("UI/PostDealt").set("visible", true)

func initial_deal_opponent() -> void:
	card_value = deal_card()
	g.opponent_cards[0] = card_value
	g.opponent_dealt_amount += 1
	card_value = deal_card()
	g.opponent_cards[1] = card_value
	g.opponent_dealt_amount += 1
	update_game.emit()
	get_node("UI/PostDealt").set("visible", true)

func next_deal_player() -> void:
	card_value = deal_card()
	if g.player_dealt_amount == 2 :
		g.player_cards[2] = card_value
		g.player_dealt_amount += 1
	elif g.player_dealt_amount == 3 :
		g.player_cards[3] = card_value
		g.player_dealt_amount += 1
	elif g.player_dealt_amount == 4 :
		g.player_cards[4] = card_value
		g.player_dealt_amount += 1
	update_game.emit()

func next_deal_opponent() -> void:
	card_value = deal_card()
	if g.opponent_dealt_amount == 2 :
		g.opponent_cards[2] = card_value
		g.opponent_dealt_amount += 1
	elif g.opponent_dealt_amount == 3 :
		g.opponent_cards[3] = card_value
		g.opponent_dealt_amount += 1
	elif g.opponent_dealt_amount == 4 :
		g.opponent_cards[4] = card_value
		g.opponent_dealt_amount += 1
	update_game.emit()

func _on_hit_pressed() -> void:
	next_deal_player()
	print("hit pressed")

func _on_stand_pressed() -> void:
	print("stand pressed")
	get_node("UI/PostDealt").set("visible", false)
	for x in range(3) :
		if opponent_decide() == true:
			next_deal_opponent()
		else:
			break

	if g.opponent_dealt_amount >= 5 or g.opponent_score > 21:
		if g.opponent_dealt_amount >= 5:
			g.win_reason = "Higher score wins."
			opponent_wins()
		elif g.opponent_score > 21:
			g.win_reason = "Went over 21."
			player_wins()
	elif g.player_score > g.opponent_score:
		g.win_reason = "Higher score wins."
		player_wins()
	elif g.opponent_score > g.player_score:
		g.win_reason = "Higher score wins."
		opponent_wins()

func _on_deal_pressed() -> void:
	initial_deal_player()
	initial_deal_opponent()
	get_node("UI/PreDealt").set("visible", false)

func _on_update_game() -> void:
	print("score update")
	g.player_score = 0
	g.opponent_score = 0
	for num in g.player_cards :
		g.player_score += num
	for num in g.opponent_cards :
		g.opponent_score += num
	get_node("UI/Text/YouScore").set("text", g.player_score)
	get_node("UI/Text/VSScore").set("text", g.opponent_score)
	if g.player_dealt_amount >= 5 or g.player_score > 21:
		if g.player_dealt_amount >= 5:
			g.win_reason = "Higher score wins."
			player_wins()
		elif g.player_score > 21:
			g.win_reason = "Went over 21."
			opponent_wins()

func next_round() -> void:
	g.player_cards = [0,0,0,0,0]
	g.player_dealt_amount = 0
	g.opponent_cards = [0,0,0,0,0]
	g.opponent_dealt_amount = 0
	g.player_score = 0
	g.opponent_score = 0
	g.round += 1
	get_node("UI/Text/RoundNo").set("text", g.round)
	get_node("Winner").set("visible", false)
	get_node("Winner/PlayerWin").set("visible", false)
	get_node("Winner/OpponentWin").set("visible", false)

func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_CTRL) and Input.is_key_pressed(KEY_ALT) and Input.is_key_pressed(KEY_D) :
		if globals.dev_mode == false :
			print("DEV MODE ENABLED")
			dev = true
			dev_mode_enabled.emit()

func opponent_decide() -> bool:
	if g.opponent_score >= 21 :
		return false
	else :
		var decision_decider = randf()
		var decision_chance = opponent_decision_chances[g.opponent_score - 1]
		if decision_decider < decision_chance :
			return true
	return false

func player_wins() -> void:
	print("player win")
	get_node("UI/PreDealt").set("visible", false)
	get_node("Winner/WinReason").set("text", g.win_reason)
	get_node("Winner").set("visible", true)
	get_node("Winner/PlayerWin").set("visible", true)

func opponent_wins() -> void:
	print("opponent win")
	get_node("UI/PreDealt").set("visible", false)
	get_node("Winner/WinReason").set("text", g.win_reason)
	get_node("Winner").set("visible", true)
	get_node("Winner/OpponentWin").set("visible", true)

func _on_play_again_pressed() -> void:
	next_round()
