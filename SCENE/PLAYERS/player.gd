extends UNIT
class_name Player


@export var dash_duration: float = 0.15
@export var dash_speed_multiplier = 3
@export var dash_cooldown = 3



@onready var trail: Trail = %Trail
 
@onready var dash_timer: Timer = $DashTimer
@onready var dash_cooldown_timer: Timer = $DashCooldownTimer
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var weapon_container: WeaponContainer = $WeaponContainer

var current_weapons: Array[Weapon] = []


var move_direction: Vector2

var is_dashing: bool = false
var dash_available: bool = true


func _ready() -> void:
	super._ready()
	dash_timer.wait_time = dash_duration
	dash_cooldown_timer.wait_time = dash_cooldown
	
	add_weapon(preload("res://RESOURCES/Items/Weapons/melee/punch/item_punch_1.tres"))
	add_weapon(preload("res://RESOURCES/Items/Weapons/range/shotgun/item_shotgun_1.tres"))

	
	
	
func _process(delta: float) -> void:
	
	## Pause game activities
	if Global.game_paused: return
	
	move_direction = Input.get_vector("move_left", "move_right","move_up","move_down")
	
	var current_velocity = move_direction * stats.speed
	
	if is_dashing:
		current_velocity *= dash_speed_multiplier
	
	position += current_velocity * delta
	position.x = clamp(position.x, -1000,1000)
	position.y = clamp(position.y, -500,500)
	
	
	if can_dash():
		start_dash()
	update_animations()
	update_rotation()


func add_weapon(data: ItemWeapon) -> void:
	var weapon = data.scene.instantiate() as Weapon
	add_child(weapon)
	
	weapon.setup_weapon(data)
	current_weapons.append(weapon)
	weapon_container.update_weapons_position(current_weapons)
	


func update_animations():
	if move_direction.length() > 0:
		anim_player.play("move")
	else:
		anim_player.play("idle")


func update_rotation():
	if move_direction == Vector2.ZERO:
		return
	if move_direction.x >= 0.1:
		visuals.scale = Vector2(-0.5, 0.5)
	else:
		visuals.scale = Vector2(0.5, 0.5)


func start_dash():
	print("Dash started")
	is_dashing = true
	dash_timer.start()
	trail.start_trail()                      ## Initiate Trail During DASH
	visuals.modulate.a = 0.5
	collision.set_deferred("disabled", true)
	
func can_dash () -> bool:
	return not is_dashing and\
	dash_cooldown_timer.is_stopped() and\
	Input.is_action_just_pressed("dash") and\
	move_direction != Vector2.ZERO


func is_facing_right() -> bool:
	return visuals.scale.x == -0.5


func _on_dash_timer_timeout() -> void:
	print("Dash ended")
	is_dashing = false
	visuals.modulate.a = 1.0
	move_direction = Vector2.ZERO
	collision.set_deferred("disabled", false)
	dash_cooldown_timer.start()
	print(dash_cooldown_timer.is_stopped())
