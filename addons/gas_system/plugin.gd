# res://addons/gas_system/plugin.gd
@tool
extends EditorPlugin
class_name GasSystemPlugin

@export var icon: Texture2D = preload("res://addons/gas_system/icons/gas_icon.svg")

# Only Targeting.gd is autoloaded (Node)
const AUTOLOADS: Dictionary = {
	"Targeting": "res://addons/gas_system/Targeting.gd"
}

# All custom types (Node or Resource)
const TYPE_INFO: Dictionary = {
	"AbilitySystem":     ["Node",     "AbilitySystem.gd"],
	"AbilityTask":       ["Node",     "AbilityTask.gd"],
	"AttributeSet":      ["Node",     "AttributeSet.gd"],
	"Targeting":         ["Node",     "Targeting.gd"],
	"WaitForChargeTask": ["Node",     "WaitForChargeTask.gd"],
	"Ability":           ["Resource", "Ability.gd"],
	"AbilityDatabase":   ["Resource", "AbilityDatabase.gd"],
	"CueDatabase":       ["Resource", "CueDatabase.gd"],
	"GameplayCue":       ["Resource", "GameplayCue.gd"],
	"GameplayEffect":    ["Resource", "GameplayEffect.gd"],
	"TargetData":        ["Resource", "TargetData.gd"],
	"TagContainer":      ["Resource", "TagContainer.gd"]
}

func _enter_tree() -> void:
	# Auto‑register Targeting as singleton
	for name in AUTOLOADS.keys():
		var key: String = "autoload/" + name
		if not ProjectSettings.has_setting(key):
			ProjectSettings.set_setting(key, AUTOLOADS[name])
	ProjectSettings.save()

	# Register custom types
	for name in TYPE_INFO.keys():
		var info: Array = TYPE_INFO[name]
		add_custom_type(name, info[0], load("res://addons/gas_system/" + info[1]), icon)

func _exit_tree() -> void:
	# Unregister custom types
	for name in TYPE_INFO.keys():
		remove_custom_type(name)
