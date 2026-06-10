#extends Node2D
#class_name FloatingText
#
#@onready var value_label: Label = $ValueLabel
#
#func setup(value: String, color: Color):
	#value_label.text = value
	#modulate = color
	#scale = Vector2.ZERO
	#
	#rotation = deg_to_rad(randf_range(-10,10))
	#
	#var random_scale = randf_range(0.8, 1.6)
	#var tween = create_tween()
	#
	#tween.parallel().tween_property(self, "scale", random_scale * Vector2.ONE, 0.4)
	#tween.parallel().tween_property(self, "global_position", global_position + Vector2.UP, 0.5)
	#
	#tween.tween_interval(0.5)
	#
	#tween.parallel().tween_property(self, "scale", Vector2.ZERO, 0.4 )
	#tween.parallel().tween_property(self, "modulate:a", 0.0, 0.4)
	#
	#await tween.finished
	#queue_free()
	#


extends Node2D
class_name FloatingText

@onready var value_label: Label = $ValueLabel

func setup(value: String, color: Color):
	value_label.text = value
	value_label.modulate = color

	# Random spawn offset
	global_position += Vector2(
		randf_range(-10, 10),
		randf_range(-10, 10)
	)

	# Initial state
	scale = Vector2.ZERO
	rotation = deg_to_rad(randf_range(-10, 10))

	var random_scale = randf_range(0.8, 1.6)

	# Random movement direction
	var target_position = global_position + Vector2(
		randf_range(-25, 25),
		randf_range(-70, -100)
	)

	var tween = create_tween()

	# Quick pop-in
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)

	tween.parallel().tween_property(
		self,
		"scale",
		Vector2.ONE * random_scale * 1.2,
		0.15
	)

	tween.parallel().tween_property(
		self,
		"global_position",
		global_position + Vector2(0, -20),
		0.15
	)

	# Settle to normal size
	tween.tween_property(
		self,
		"scale",
		Vector2.ONE * random_scale,
		0.1
	)

	# Float upward
	tween.parallel().tween_property(
		self,
		"global_position",
		target_position,
		0.6
	)

	# Small delay
	tween.tween_interval(0.2)

	# Fade out and shrink
	tween.parallel().tween_property(
		self,
		"scale",
		Vector2.ZERO,
		0.3
	)

	tween.parallel().tween_property(
		self,
		"modulate:a",
		0.0,
		0.3
	)

	await tween.finished
	queue_free()
