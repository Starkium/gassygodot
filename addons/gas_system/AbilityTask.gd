# res://addons/gas_system/AbilityTask.gd
extends Node
class_name AbilityTask

signal completed(data)

func start(params: Dictionary = {}) -> void:
	pass

func _finish(data = null) -> void:
	emit_signal("completed", data)
	queue_free()
