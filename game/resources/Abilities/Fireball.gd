# res://game/scripts/abilities/Fireball.gd
extends Ability

@export var projectile_scene: PackedScene

func execute(asc) -> void:
	# Spawn a projectile at the mage's position
	var mage = asc.get_parent() as Node3D
	var proj = projectile_scene.instantiate()
	proj.global_transform.origin = mage.global_transform.origin
	proj.global_transform.basis = mage.global_transform.basis
	# Add to the current scene
	mage.get_tree().current_scene.add_child(proj)
