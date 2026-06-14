extends Node2D
class_name UNIT


@export var stats: UnitStats

@onready var visuals: Node2D = %Visuals
@onready var sprite: Sprite2D = %sprite
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var health_components: HealthComponents = $HealthComponents
@onready var flash_timer: Timer = $FlashTimer



func _ready():
	health_components.setup(stats)


func set_flash_material():
	sprite.material = Global.FLASH_MATERIALS
	flash_timer.start()

func _on_hurt_box_components_on_damage(hitbox: HitBoxComponents) -> void:
	if health_components.current_health <= 0:
		return
		
	var blocked = Global.get_chance_success(stats.block_chance / 100)
	if blocked:
		Global.on_create_block_text.emit(self)
		print("Blocked!")
		return
	
	
	
	set_flash_material()
	Global.on_create_damage_text.emit(self, hitbox)
	health_components.take_damage(hitbox.damage)
	print("%s: %d" % [name, health_components.current_health])


func _on_flash_timer_timeout() -> void:
	sprite.material = null
