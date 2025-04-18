# res://addons/gas_system/TagContainer.gd
extends Resource
class_name TagContainer

var active_ids: Array[int] = []

func add(name: String) -> void:
	var id: int = TagRegistry.get_tag_id(name)
	if id == 0:
		id = TagRegistry.register_tag(name)
	if id not in active_ids:
		active_ids.append(id)

func has(name: String) -> bool:
	return TagRegistry.get_tag_id(name) in active_ids

func remove(name: String) -> void:
	var id: int = TagRegistry.get_tag_id(name)
	active_ids.erase(id)
