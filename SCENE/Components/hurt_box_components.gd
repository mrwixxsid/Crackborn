extends Area2D
class_name HurtBoxComponents



signal on_damage(hitbox: HitBoxComponents)


func _on_area_entered(area: Area2D) -> void:
	if area is HitBoxComponents:
		on_damage.emit(area)
		print("Git Hit")
		
	#if area.is_in_group("Player"):
		#print("Collided")
