# res://addons/gas_system/CueDatabase.gd
extends Resource
class_name CueDatabase

@export var tag_to_cue: Dictionary = {}

func get_cue(tag: String) -> GameplayCue:
	return tag_to_cue.get(tag, null)
