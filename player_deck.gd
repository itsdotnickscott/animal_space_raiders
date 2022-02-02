class_name PlayerDeck
extends Reference


var deck : Array = []
var pos : int = -1


func _init(team) -> void:
	randomize()

	for unit in team:
		for ability in unit.get_abilities():
			deck.append(ability)


func deal() -> Ability:
	pos += 1
	if pos >= deck.size():
		shuffle()

	return deck[pos]


func shuffle() -> void:
	pos = -1
	deck.shuffle()