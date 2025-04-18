# res://addons/gas_system/TargetData.gd
extends Resource
class_name TargetData

@export var hit_bodies: Array[NodePath] = []
@export var hit_position: Vector3 = Vector3.ZERO
@export var instigator: NodePath

func get_bodies(root: Node) -> Array:
	var bodies: Array = []
	for p in hit_bodies:
		if root.has_node(p):
			bodies.append(root.get_node(p))
	return bodies
