# res://addons/gas_system/AbilitySystem.gd
extends Node
class_name AbilitySystem

var abilities: Array = []
var tags = preload("res://addons/gas_system/TagContainer.gd").new()
var attribute_set: AttributeSet
var _active_effects: Array = []

func _ready() -> void:
	attribute_set = get_node("../AttributeSet")
	set_process(true)

func grant(ability: Ability) -> void:
	if ability not in abilities:
		abilities.append(ability)

func try_activate_by_tag(tag: String) -> bool:
	for ab in abilities:
		if ab.ability_tag == tag and ab.can_activate(self):
			ab.activate(self)
			return true
	return false

func apply_effect(effect: GameplayEffect) -> void:
	effect.apply_to(self)

func _queue_effect(effect: GameplayEffect) -> void:
	for e in _active_effects:
		if e.effect == effect:
			match effect.stacking_rule:
				GameplayEffect.Stacking.REPLACE:
					_cancel_effect(e)
					break
				GameplayEffect.Stacking.REFRESH:
					e.timer.start()
					return
				GameplayEffect.Stacking.STACK:
					pass
	_start_effect(effect)

func _start_effect(effect: GameplayEffect) -> void:
	effect._apply_once(attribute_set)
	var entry = {"effect":effect, "elapsed":0.0, "timer":null}
	if effect.period > 0.0:
		var t = Timer.new()
		t.wait_time = effect.period
		t.one_shot = false
		t.timeout.connect(Callable(self, "_on_effect_tick"), [effect])
		add_child(t)
		t.start()
		entry.timer = t
	_active_effects.append(entry)

func _on_effect_tick(effect: GameplayEffect) -> void:
	effect._apply_once(attribute_set)

func _process(delta: float) -> void:
	for e in _active_effects.duplicate():
		e.elapsed += delta
		if e.elapsed >= e.effect.duration:
			_cancel_effect(e)

func _cancel_effect(entry) -> void:
	if entry.timer:
		entry.timer.queue_free()
	_active_effects.erase(entry)
