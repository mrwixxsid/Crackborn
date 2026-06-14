extends Area2D
class_name HitBoxComponents

signal on_hit_hurtbox(hurtbox: HurtBoxComponents)


var damage = 1
var critical = false
var knock_back_power = 0.0
var source: Node2D

func enable() -> void:
	set_deferred("monitoring", true)
	set_deferred("monitorable", true)

func disable():
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)

func setup(damage, critical, knock_back, source):
	self.damage = damage
	self.critical = critical
	knock_back_power = knock_back
	self.source = source



func _on_area_entered(area: Area2D) -> void:
	if area is HurtBoxComponents:
		on_hit_hurtbox.emit(area)
		print(area.owner.name)
