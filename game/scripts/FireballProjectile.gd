# res://game/scripts/FireballProjectile.gd
extends Area3D

@export var speed: float = 20.0
@export var damage_effect: GameplayEffect

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))

func _physics_process(delta: float) -> void:
	# Move forward in local Z
	translate(transform.basis.z * speed * delta)

func _on_body_entered(body: Node) -> void:
	if body.has_method("apply_effect"):
		body.apply_effect(damage_effect)
	queue_free()
