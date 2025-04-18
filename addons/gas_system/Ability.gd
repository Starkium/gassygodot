# res://addons/gas_system/Ability.gd
extends Resource
class_name Ability

@export var ability_tag:    String     = ""
@export var blocked_tags:   Array      = []
@export var cooldown:       float      = 0.0
@export var cost:           Dictionary = {}
@export var required_tags:  Array      = []

var _on_cooldown: bool = false

func can_activate(asc) -> bool:
	if _on_cooldown:
		return false
	for tag in blocked_tags:
		if asc.tags.has(tag):
			return false
	for tag in required_tags:
		if not asc.tags.has(tag):
			return false
	for stat in cost.keys():
		if asc.attribute_set.attributes.get(stat, 0) < cost[stat]:
			return false
	return true

func activate(asc) -> void:
	for stat in cost.keys():
		asc.attribute_set.modify(stat, -cost[stat])
	execute(asc)
	if cooldown > 0.0:
		_on_cooldown = true
		var t = Timer.new()
		t.wait_time = cooldown
		t.one_shot = true
		t.timeout.connect(Callable(self, "_end_cooldown"))
		asc.add_child(t)
		t.start()

func _end_cooldown() -> void:
	_on_cooldown = false

func execute(asc) -> void:
	push_error("Ability.execute() must be overridden")
