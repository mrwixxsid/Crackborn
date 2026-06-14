extends Node2D
class_name Projectile

@export var HitBox: HitBoxComponents

var velocity: Vector2

func _process(delta: float) -> void:
	position += velocity * delta

func set_projectile(velocity: Vector2, damage: float, critical: bool, knockback: float, unit: Node2D):
	self.velocity = velocity
	rotation = velocity.angle()
	
	if HitBox:
		HitBox.setup(damage, critical, knockback, unit)




func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()


func _on_hit_box_component_on_hit_hurtbox(hurtbox: HurtBoxComponents) -> void:
	queue_free()
