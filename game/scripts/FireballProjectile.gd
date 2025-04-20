# res://game/scripts/FireballProjectile.gd
extends Area3D

@export var speed: float = 20.0
@export var damage_effect: GameplayEffect
var instigator: Node3D

func _ready() -> void:
	print("[FireballProjectile] spawned at", global_transform.origin)
	connect("body_entered", Callable(self, "_on_body_entered"))

func _physics_process(delta: float) -> void:
	# Move in the firing direction
	var direction: Vector3 = -transform.basis.z.normalized()
	translate(direction * speed * delta)


func _on_body_entered(body: Node) -> void:
	if body == instigator:
		return  # ignore self-collision
	print("[FireballProjectile] collided with", body.name)
	if body.has_method("apply_effect"):
		body.apply_effect(damage_effect)
	queue_free()
