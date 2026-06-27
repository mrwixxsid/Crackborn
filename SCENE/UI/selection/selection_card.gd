extends Button
class_name SelectionCard


func set_icon(texture: Texture2D):
	icon = texture


func _on_pressed() -> void:
	SoundManager.play_sound(SoundManager.Sound.UI)
