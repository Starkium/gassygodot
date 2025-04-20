# res://game/scripts/Mage.gd
extends CharacterBody3D

@export var speed: float
@export var CROUCH_SPEED: float = 1.0
@export var WALK_SPEED:float = 4.0
@export var SPRINT_SPEED:float = 9.0
@export var JUMP_VELOCITY: float = 4.5
@export var GRAVITY: float = 9.8
@export var SENSITIVITY:float = 0.001
@export var ACCELERATION: float = 5.0

@onready var asc: AbilitySystem = $AbilitySystem
@onready var head_target: Node3D = $headTarget
@onready var camera_target: Node3D = $headTarget/cameraTarget
@onready var actual_head: Node3D = $actualHead
@onready var actual_camera: Camera3D = $actualHead/actualCamera

func _ready() -> void:
	# Grant our abilities so try_activate_by_tag() can find them
	asc.grant(load("res://game/resources/Abilities/Fireball.tres"))
	asc.grant(load("res://game/resources/Abilities/ArcaneShield.tres"))
	asc.grant(load("res://game/resources/Abilities/BlinkDash.tres"))
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head_target.rotate_y(-event.relative.x * SENSITIVITY)
		camera_target.rotate_x(-event.relative.y * SENSITIVITY)
		camera_target.rotation.x = clamp(camera_target.rotation.x, deg_to_rad(-80), deg_to_rad(80))


func _physics_process(delta: float) -> void:
	actual_head.position.x = lerp(actual_head.position.x, position.x, ACCELERATION * 5 * delta)
	actual_head.position.z = lerp(actual_head.position.z, position.z, ACCELERATION * 5 * delta)
	actual_camera.rotation.x = lerp_angle(actual_camera.rotation.x, camera_target.rotation.x, ACCELERATION * 3 * delta)
	actual_head.rotation.y = lerp_angle(actual_head.rotation.y, head_target.rotation.y, ACCELERATION * 3 * delta)
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= GRAVITY * delta

	# Handle jump.
	if Input.is_action_just_pressed("JUMP") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_pressed("CROUCH"):
		speed = CROUCH_SPEED
		actual_head.position.y = lerp(actual_head.position.y, position.y - 0.5, delta * ACCELERATION * 4)
	elif Input.is_action_pressed("SPRINT"):
		speed = SPRINT_SPEED
		actual_head.position.y = lerp(actual_head.position.y, position.y, delta * ACCELERATION * 4)
	else:
		speed = WALK_SPEED
		actual_head.position.y = lerp(actual_head.position.y, position.y, delta * ACCELERATION * 4)
	
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("LEFT", "RIGHT", "FORWARD", "BACKWARD")
	var direction = (actual_head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = lerp(velocity.x, direction.x * speed, ACCELERATION * delta * 2)
			velocity.z = lerp(velocity.z, direction.z * speed, ACCELERATION * delta * 2)
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, ACCELERATION * delta)
			velocity.z = lerp(velocity.z, direction.z * speed, ACCELERATION * delta)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, ACCELERATION * delta * 0.5)
		velocity.z = lerp(velocity.z, direction.z * speed, ACCELERATION * delta * 0.5)

	move_and_slide()

	if Input.is_action_just_pressed("cast_fireball"):
		asc.try_activate_by_tag("Ability.Fireball")
	elif Input.is_action_just_pressed("arcane_shield"):
		asc.try_activate_by_tag("Ability.ArcaneShield")
	elif Input.is_action_just_pressed("blink_dash"):
		asc.try_activate_by_tag("Ability.BlinkDash")
