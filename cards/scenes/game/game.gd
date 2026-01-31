extends Node2D

var g = globals

signal set_card1(value)
signal set_card2(value)
signal set_card3(value)
signal set_card4(value)
signal set_card5(value)
signal opponent_card1(value)
signal opponent_card2(value)
signal opponent_card3(value)
signal opponent_card4(value)
signal opponent_card5(value)
signal set_score(player_value, opponent_value)

var card_value = 0

func _ready() -> void:
	pass

func deal_card() -> int:
	return (randi() % 2 + 1)

func initial_deal_player() -> void:
	for x in range(2) :
		card_value = deal_card()
		print("Card no {x} will be {card_value}.")
		g.player_cards.append(card_value)
		print("Card no {x} is added.")
	set_card1.emit(g.player_cards[0])
	g.player_dealt_amount += 1
	set_card2.emit(g.player_cards[1])
	g.player_dealt_amount += 1
	get_node("UI/PostDealt").set("visible", true)

func initial_deal_opponent() -> void:
	for x in range(2) :
		card_value = deal_card()
		print("Card no {x} will be {card_value}.")
		g.opponent_cards.append(card_value)
		print("Card no {x} is added.")
	opponent_card1.emit(g.opponent_cards[0])
	g.opponent_dealt_amount += 1
	opponent_card2.emit(g.opponent_cards[1])
	g.opponent_dealt_amount += 1
	get_node("UI/PostDealt").set("visible", true)

func next_deal_player() -> void:
	card_value = deal_card()
	if g.player_dealt_amount == 2 :
		set_card3.emit(card_value)
		g.player_dealt_amount += 1
	elif g.player_dealt_amount == 3 :
		set_card4.emit(card_value)
		g.player_dealt_amount += 1
	elif g.player_dealt_amount == 4 :
		set_card5.emit(card_value)
		g.player_dealt_amount += 1

func next_deal_opponent() -> void:
	card_value = deal_card()
	if g.player_dealt_amount == 2 :
		set_card3.emit(card_value)
		g.player_dealt_amount += 1
	elif g.player_dealt_amount == 3 :
		set_card4.emit(card_value)
		g.player_dealt_amount += 1
	elif g.player_dealt_amount == 4 :
		set_card5.emit(card_value)
		g.player_dealt_amount += 1

func _on_hit_pressed() -> void:
	next_deal_player()
	print("hit pressed")

func _on_stand_pressed() -> void:
	get_node("UI/PostDealt").set("visible", false)
	print("stand pressed")

func _on_deal_pressed() -> void:
	initial_deal_player()
	get_node("UI/PreDealt").set("visible", false)
