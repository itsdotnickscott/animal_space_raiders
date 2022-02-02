class_name Card
extends Button


var ability : Ability


func _init(ability_param : Ability) -> void:
	ability = ability_param

	var font = DynamicFont.new()
	font.font_data = load("res://assets/fonts/m3x6.ttf")
	set("custom_fonts/font", font)

	text = ability.descrip