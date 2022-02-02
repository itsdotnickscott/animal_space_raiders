class_name Battle
extends Node2D


enum Team {ALLY, ENEMY}
enum GameState {ABILITY, TARGET}
const HAND_SIZE = 4

var teams : Array = []
export var unit_ids : Array = ["","","","","","","",""]

var decks : Array = []
var team_energy : Array = [0, 0]
var energy_gain : int = 1

var curr_team : int
var curr_hand : Array = []
var game_state : int = GameState.ABILITY
var ability: Ability = null
var target: Unit = null


func _ready() -> void:
	teams =[[$Unit1, $Unit2, $Unit3, $Unit4], [$Unit5, $Unit6, $Unit7, $Unit8]]

	connect_PlayerHandUI_signals()
	connect_unit_signals()

	start_battle()


func connect_PlayerHandUI_signals():
	var error_code = $PlayerHandUI.connect("card_pressed", self, "_on_Card_pressed")
	if error_code:
		print(error_code)

	error_code = $PlayerHandUI.connect("end_turn", self, "start_turn")
	if error_code:
		print(error_code)


func connect_unit_signals():
	var i = 0
	for team in teams:
		for unit in team:
			unit.init(unit_ids[i])
			i += 1

			var error_code = unit.connect("selected", self, "_on_Unit_selected")
			if error_code:
				print(error_code)

			error_code = unit.connect("hp_depleted", self, "_on_Unit_death")
			if error_code:
				print(error_code)


func start_battle() -> void:
	for team in teams:
		decks.append(PlayerDeck.new(team))

	curr_team = Team.ENEMY
	start_turn()


func start_turn() -> void:
	curr_team = Team.ALLY if curr_team == Team.ENEMY else Team.ENEMY
	curr_hand = []
	game_state = GameState.ABILITY
	ability = null
	target = null

	for i in HAND_SIZE:
		curr_hand.append(decks[curr_team].deal())

	$PlayerHandUI.create_hand(curr_hand)

	team_energy[curr_team] += energy_gain

	if curr_team == Team.ENEMY:
		enemy_turn()


func enemy_turn() -> void:
	var rng = RandomNumberGenerator.new()
	var turn = true
	while(turn):
		var ability_choice = rng.randi_range(0, curr_hand.size() - 1)
		ability = curr_hand[ability_choice]

		var targ_choice = rng.randi_range(0, teams[Team.ALLY].size() - 1)
		target = teams[Team.ALLY][targ_choice]

		execute_ability()

		if curr_hand.size() == 0:
			turn = false

	start_turn()


func execute_ability() -> void:
	for action in ability.sequence:
		execute_damage(action)

	$PlayerHandUI.use_card(ability)
	
	if curr_hand.size() == 0:
		start_turn()

	curr_hand.erase(ability)
	
	game_state = GameState.ABILITY
	ability = null
	target = null


func execute_damage(action: Action) -> void:
	var dmg = target.take_damage(target.get_scaling_stat(action.scaling_type) * action.scaling)
	print(target.name + " took " + String(dmg) + " damage.")


func _on_Card_pressed(card: Ability) -> void:
	if card.cost > team_energy[Team.ALLY]:
		print("Not enough energy!")

	ability = curr_hand[curr_hand.find(card)]
	game_state = GameState.TARGET


func _on_Unit_selected(unit : Unit) -> void:
	if game_state == GameState.TARGET:
		target = unit
		execute_ability()


func _on_Unit_death(unit : Unit) -> void:
	unit.visible = false
	
	for team in teams:
		team.erase(unit)
		return