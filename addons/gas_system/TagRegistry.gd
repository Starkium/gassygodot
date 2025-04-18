# res://addons/gas_system/TagRegistry.gd
extends Resource
class_name TagRegistry

# Static registry (no autoload needed)
static var tags: Dictionary = {}
static var next_id: int = 1

static func register_tag(name: String) -> int:
	if not tags.has(name):
		tags[name] = next_id
		next_id += 1
	return tags[name]

static func get_tag_id(name: String) -> int:
	return tags.get(name, 0)

static func is_valid(name: String) -> bool:
	return tags.has(name)
