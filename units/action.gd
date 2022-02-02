class_name Action
extends Resource


enum ActionType {DMG, HEAL, SHIELD, BURN}
enum Targeting {ANY, FRONT_1, FRONT_ALL, BACK_1, BACK_ALL, LINE_1, LINE_2, ALL}
enum ScalingType {ATTACK, MAGIC}

export (ActionType) var action_type
export (Targeting) var targeting
export (ScalingType) var scaling_type
export var scaling : float