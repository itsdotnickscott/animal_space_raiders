extends Control


signal card_pressed(ability)
signal end_turn()

var hand : Array


func create_hand(abilities: Array) -> void:
	for card in hand:
		card.call_deferred("free")
		
	hand = []
	for ability in abilities:
		var card = Card.new(ability)
		hand.append(card)

		$HBoxContainer.call_deferred("add_child", card)

		card.connect("pressed", self, "_on_Card_pressed", [ability])


func _on_Card_pressed(ability: Ability) -> void:
	emit_signal("card_pressed", ability)


func use_card(ability: Ability) -> void:
	for card in hand:
		if card.ability == ability:
			card.visible = false
			hand.erase(card)
			return


func _on_EndTurnButton_pressed() -> void:
	emit_signal("end_turn")