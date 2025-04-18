# res://game/scripts/Mage.gd
extends CharacterBody3D

@export var speed: float = 5.0
@export var jump_velocity: float = 4.5
@export var gravity: float = 9.8
@onready var asc: AbilitySystem = $AbilitySystem

func _physics_process(delta: float) -> void:
	var dir: Vector3 = Vector3.ZERO
	if Input.is_action_pressed("move_forward"): dir -= transform.basis.z
	if Input.is_action_pressed("move_back"):    dir += transform.basis.z
	if Input.is_action_pressed("move_left"):    dir -= transform.basis.x
	if Input.is_action_pressed("move_right"):   dir += transform.basis.x
	dir = dir.normalized()

	velocity.x = dir.x * speed
	velocity.z = dir.z * speed
	if not is_on_floor():
		velocity.y -= gravity * delta
	elif Input.is_action_just_pressed("jump"):
		velocity.y = jump_velocity

	# Move the character; returns true if collided
	move_and_slide()

	if Input.is_action_just_pressed("cast_fireball"):
		asc.try_activate_by_tag("Ability.Fireball")
		print("called fireball")
	elif Input.is_action_just_pressed("arcane_shield"):
		asc.try_activate_by_tag("Ability.ArcaneShield")
		print("called arcane shield")
	elif Input.is_action_just_pressed("blink_dash"):
		asc.try_activate_by_tag("Ability.BlinkDash")
		print("called blink dash")
