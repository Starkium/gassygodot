# res://addons/gas_system/AttributeSet.gd
extends Node
class_name AttributeSet

signal attribute_changed(name: String, new_value: float)

var attributes: Dictionary = {
	"health": 100.0,
	"mana":   100.0,
	"stamina": 50.0,
}

func modify(name: String, delta: float) -> void:
	if not attributes.has(name):
		push_error("Unknown attribute: %s" % name)
		return
	attributes[name] = clamp(attributes[name] + delta, 0.0, INF)
	emit_signal("attribute_changed", name, attributes[name])
