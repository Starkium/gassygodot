# res://addons/gas_system/AbilityDatabase.gd
extends Resource
class_name AbilityDatabase

@export var tag_to_ability: Dictionary = {}

func get_ability(tag: String) -> Ability:
	return tag_to_ability.get(tag, null)
