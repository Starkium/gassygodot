# res://addons/gas_system/GameplayEffect.gd
extends Resource
class_name GameplayEffect

enum Stacking { REPLACE, STACK, REFRESH }

@export var add_tags:      Array      = []
@export var attribute_mods: Dictionary = {}
@export var duration:      float      = 0.0
@export var period:        float      = 0.0
@export var remove_tags:   Array      = []
@export var stacking_rule: int        = Stacking.REPLACE

func apply_to(asc) -> void:
	for t in add_tags:
		asc.tags.add(t)
	for t in remove_tags:
		asc.tags.remove(t)
	if duration <= 0.0:
		_apply_once(asc.attribute_set)
	else:
		asc._queue_effect(self)

func _apply_once(attr_set) -> void:
	for name in attribute_mods.keys():
		attr_set.modify(name, attribute_mods[name])
