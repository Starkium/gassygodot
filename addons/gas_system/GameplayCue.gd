# res://addons/gas_system/GameplayCue.gd
extends Resource
class_name GameplayCue

@export var sfx_stream: AudioStream
@export var vfx_scene:  PackedScene

func play(origin: Node) -> void:
	if vfx_scene:
		var inst = vfx_scene.instantiate()
		origin.add_child(inst)
	if sfx_stream:
		var player = AudioStreamPlayer3D.new()
		player.stream = sfx_stream
		origin.add_child(player)
		player.play()
