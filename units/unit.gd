class_name Unit
extends Node2D


signal selected(unit)
signal hp_depleted(unit)

var unit_info : UnitInfo
var hp : int


func init(hero_id: String) -> void:
	unit_info = load("res://units/heroes/" + hero_id + ".tres")
	hp = unit_info.base_hp
	update_hp()


func take_damage(dmg) -> float:
	hp -= dmg
	update_hp()

	if hp <= 0:
		emit_signal("hp_depleted", self)

	return dmg


func update_hp() -> void:
	$HPLabel.text = String(hp) + "HP"


func get_abilities() -> Array:
	return unit_info.ability_set


func get_hp() -> int:
	return hp


func get_scaling_stat(stat: int) -> int:
	if stat == Action.ScalingType.ATTACK:
		return unit_info.base_atk
	else:
		return unit_info.base_mag


func _on_Unit_input_event(_viewport, event, _shapeidx) -> void:
	if (event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT):
		emit_signal("selected", self)