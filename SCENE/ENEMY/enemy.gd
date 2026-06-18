extends UNIT
class_name Enemy

@export var flock_push = 20
@onready var vision_area: Area2D = $VisionArea
@onready var knock_back_timer: Timer = $KnockBackTimer


var can_move = true

var knockback_dir: Vector2
var knockback_power: float

func _process(delta: float) -> void:
	
	## Pause game activities
	if Global.game_paused: return 
	
	if not can_move:
		return
	if not can_move_towards_player():
		return
		
	position += (get_move_direction() + knockback_dir * knockback_power) * stats.speed * delta
	update_rotation()
	
	
func get_move_direction() -> Vector2:
	if not is_instance_valid(Global.player):
		return Vector2.ZERO
	
	var direction = global_position.direction_to(Global.player.global_position)
	
	for area: Node2D in vision_area.get_overlapping_areas():
		if area != self and area.is_inside_tree():
			var vector = global_position - area.global_position
			direction += flock_push * vector.normalized() / vector.length()
	
	return direction
		

func update_rotation():
	if not is_instance_valid(Global.player):
		return
	
	var player_position = Global.player.global_position
	var moving_right = global_position.x < player_position.x
	visuals.scale = Vector2(-0.5, 0.5) if moving_right else Vector2(0.5,0.5)


func can_move_towards_player() -> bool:
	return is_instance_valid(Global.player) and\
	global_position.distance_to(Global.player.global_position) > 45 ## Pixel Distane between enemies

func apply_knockback(knock_dir: Vector2, knock_power: float):
	knockback_dir = knock_dir
	knockback_power = knock_power
	
	if knock_back_timer.time_left > 0:
		knock_back_timer.stop()
		#reset_knockback()
	knock_back_timer.start()
func reset_knockback():
	knockback_dir = Vector2.ZERO
	knockback_power = 0.0


func distry_enemy():
	can_move = false
	anim_player.play("die")
	await anim_player.animation_finished
	queue_free()





func _on_knock_back_timer_timeout() -> void:
	reset_knockback()
	
func _on_hurt_box_components_on_damage(hitbox: HitBoxComponents) -> void:
	
	super._on_hurt_box_components_on_damage(hitbox)
	
	if hitbox.knock_back_power > 0:
		var dir:= hitbox.source.global_position.direction_to(global_position)
		apply_knockback(dir, hitbox.knock_back_power)
