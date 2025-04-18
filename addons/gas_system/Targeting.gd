# res://addons/gas_system/Targeting.gd
extends Node
class_name Targeting

func line_trace(origin: Vector3, dir: Vector3, length: float = 1000.0) -> TargetData:
	var space = get_tree().current_scene.get_world_3d().direct_space_state
	var res = space.intersect_ray(origin, origin + dir.normalized() * length)
	var td = TargetData.new()
	if res:
		td.hit_position = res.position
		td.hit_bodies = [res.collider.get_path()]
	return td

func sphere_overlap(center: Vector3, radius: float) -> TargetData:
	var shape = SphereShape3D.new()
	shape.radius = radius
	var params = PhysicsShapeQueryParameters3D.new()
	params.shape = shape
	params.transform = Transform3D(Basis(), center)
	var results = get_tree().current_scene.get_world_3d().direct_space_state.intersect_shape(params)
	var td = TargetData.new()
	var paths: Array = []
	for r in results:
		paths.append(r.collider.get_path())
	td.hit_bodies = paths
	return td
