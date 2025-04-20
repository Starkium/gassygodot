# res://game/scripts/abilities/Fireball.gd
extends Ability

@export var projectile_scene: PackedScene

func execute(asc) -> void:
	print("[Fireball] execute called for ability_tag=", ability_tag)
	var proj = projectile_scene.instantiate() as Area3D
	var spawn_Transform: Transform3D
	
	proj.instigator = asc.get_parent() as Node3D
	asc.get_parent().get_tree().current_scene.add_child(proj)

	proj.global_transform = spawn_Transform
	print("[Fireball] spawning projectile at", spawn_Transform.origin)
