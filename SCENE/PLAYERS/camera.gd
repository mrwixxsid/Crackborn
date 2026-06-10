extends Camera2D
class_name Camera

@export var follow_speed: float = 8.0
 


func _process(delta: float) -> void:
	if !is_instance_valid(Global.player):
		return

	global_position = global_position.lerp(
		Global.player.global_position,
		1.0 - exp(-follow_speed * delta)
	)
