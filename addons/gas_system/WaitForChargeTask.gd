# res://addons/gas_system/WaitForChargeTask.gd
extends AbilityTask
class_name WaitForChargeTask

@export var charge_time: float = 0.5

func start(params: Dictionary = {}) -> void:
	var t = Timer.new()
	t.wait_time = charge_time
	t.one_shot = true
	t.timeout.connect(Callable(self, "_finish"))
	add_child(t)
	t.start()
