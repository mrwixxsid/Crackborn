extends Node2D
class_name Arena


#@export var player: Player

@export var normal_color: Color
@export var blocked_color: Color
@export var critical_color: Color
@export var hp_color: Color 

@onready var coins_bar: CoinsBar = %CoinsBar

## Game UI
@onready var wave_index_label: Label = %WaveIndexLabel
@onready var wave_time_lable: Label = %WaveTimeLable

## Spawner
@onready var spawner: Spawner = $Spawner

## Upgrade panel UI
@onready var upgrade_panel: Upgrade_Panel = %Upgrade_Panel
## SHOP PANEL
@onready var shop_panel: ShopPanel = %ShopPanel


var gold_list: Array[Coins]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Global.player = player
	Global.on_create_block_text.connect(_on_create_block_text)
	Global.on_create_damage_text.connect(_on_create_damage_text)
	Global.on_upgrade_selected.connect(_on_upgrade_selected)
	Global.on_create_heal_text.connect(_on_create_heal_text)
	Global.on_enemy_died.connect(_on_enemy_died)
	
	## START WAVE
	## NOW STARTS FROM SELECTION PANEL
	#spawner.start_wave()



func _process(delta: float) -> void:
	if Global.game_paused: return
	wave_index_label.text = spawner.get_wave_text()
	wave_time_lable.text = spawner.get_wave_timer_text()
	


func create_floating_text(unit :Node2D):
	var instance = Global.FLOATING_TEXT.instantiate() as FloatingText
	get_tree().root.add_child(instance)
	var random_pos = randf_range(0,TAU) * 35 #random position near player
	var spawn_pos = unit.global_position + Vector2.RIGHT.rotated(random_pos)
	
	instance.global_position = spawn_pos
	return instance
	
	
func _on_create_block_text(unit :Node2D):
	var text = create_floating_text(unit)
	text.setup("Blocked", blocked_color)
func _on_create_damage_text(unit :Node2D, hitbox: HitBoxComponents):
	var text = create_floating_text(unit)
	var color = critical_color if hitbox.critical else normal_color
	text.setup(str(hitbox.damage), color)


func _on_create_heal_text(unit: Node2D, heal: float):
	var text = create_floating_text(unit)
	text.setup("+ %s" %heal, hp_color)
	


func show_upgrades():
	upgrade_panel.load_upgrade(spawner.wave_index)
	upgrade_panel.show()

func _on_upgrade_selected():
	upgrade_panel.hide()
	shop_panel.load_shop(spawner.wave_index)
	shop_panel.show()
	
func start_new_wave():
	Global.game_paused = false
	Global.player.update_player_new_wave()
	spawner.wave_index += 1
	spawner.start_wave()
	



func clean_arena():
	if gold_list.size() > 0:
		var target_center_pos = coins_bar.global_position + coins_bar.size / 2
		
		for gold in gold_list:
			if is_instance_valid(gold):
				var gold_item = gold as Coins
				gold_item.set_collection_target(target_center_pos)
	gold_list.clear()
	spawner.clear_enemies()




func spawn_coins(enemy: Enemy):
	var random_angle = randf_range(0, TAU)
	var offset = Vector2.RIGHT.rotated(random_angle) * 35
	var spawn_pos = enemy.global_position + offset
	
	var gold_instance = Global.COINS_SCENE.instantiate() as Coins
	gold_list.append(gold_instance)
	
	gold_instance.global_position = spawn_pos
	gold_instance.value = enemy.stats.gold_drop
	call_deferred("add_child", gold_instance)


func _on_spawner_on_wave_completed() -> void:
	if not Global.player: return
	clean_arena()
	await get_tree().create_timer(1).timeout
	show_upgrades()
	clean_arena()


func _on_shop_panel_shop_next_wave() -> void:
	shop_panel.hide()
	start_new_wave()


func _on_enemy_died(enemy: Enemy):
	spawn_coins(enemy)


func _on_selection_panel_on_selection_completed() -> void:
	var player = Global.get_selected_player()
	add_child(player)
	player.add_weapon(Global.main_weapon_selected)
	shop_panel.create_item_weapon(Global.main_weapon_selected)
	Global.equipped_weapon.append(Global.main_weapon_selected)
	
	spawner.start_wave()
	Global.game_paused = false
