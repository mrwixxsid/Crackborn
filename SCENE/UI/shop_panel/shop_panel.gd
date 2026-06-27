extends Panel
class_name ShopPanel


signal shop_next_wave

const SHOP_CARD = preload("uid://c3vux68ew3i1d")


@export var shop_items: Array[ItemBase]

@onready var items_container: HBoxContainer = %ItemsContainer
@onready var passive_container: GridContainer = %PassiveContainer
@onready var weapons_container: GridContainer = %WeaponsContainer

@onready var combine_button: Button = %CombineButton


var context_card: ItemCard


func _ready() -> void:
	for child in passive_container.get_children(): child.queue_free()
	for child in weapons_container.get_children(): child.queue_free()


func load_shop(current_wave: int):
	for child in items_container.get_children(): child.queue_free()
	
	var config = Global.SHOP_PROBABLITY_CONFIG
	var selected_items = Global.select_item_for_offer(shop_items, current_wave, config)
	
	for shop_item: ItemBase in selected_items:
		var card_instance = SHOP_CARD.instantiate() as ShopCard
		card_instance.on_item_purchased.connect(_on_item_purchased)
		items_container.add_child(card_instance)
		card_instance.shop_item = shop_item
	


func create_item_card() -> ItemCard:
	var item_card = Global.ITEM_CARD_SCENE.instantiate() as ItemCard
	item_card.on_item_card_selected.connect(_on_item_card_selected)
	return item_card


func create_item_weapon(weapon: ItemWeapon):
	var card = create_item_card()
	weapons_container.add_child(card)
	card.item = weapon

func _on_new_wave_button_pressed() -> void:
	SoundManager.play_sound(SoundManager.Sound.UI)
	shop_next_wave.emit()


func _on_item_purchased(item: ItemBase):
	var item_card = create_item_card()
	if item.item_type == ItemBase.ItemType.WEAPON:
		weapons_container.add_child(item_card)
		var weapon = item as ItemWeapon
		Global.player.add_weapon(weapon)
		Global.equipped_weapon.append(weapon)
		
	
	elif item.item_type == ItemBase.ItemType.PASSIVE:
		passive_container.add_child(item_card)
		var passive = item as ItemPassives
		passive.apply_passive()
		
		
	item_card.item = item
	
func _on_item_card_selected(card: ItemCard):
	context_card = card
	
	var can_marge = false
	if card.item.item_type == ItemBase.ItemType.WEAPON:
		
		var count = 0
		
		for weapons: ItemWeapon in Global.equipped_weapon:
			if weapons.item_name == card.item.item_name:
				count += 1
				
		if count >= 2:
			can_marge = true
	combine_button.disabled = not can_marge


func _on_combine_button_pressed() -> void:
	if not context_card:
		return
	SoundManager.play_sound(SoundManager.Sound.UI)
	var clicked_weapon = context_card.item as ItemWeapon
	
	if not clicked_weapon.upgrade_to:
		return
		
	
	var weapons_to_remove: Array[Weapon] = Global.player.current_weapons.filter(func(w: Weapon): 
		return w.data.item_name == clicked_weapon.item_name).slice(0,2)
	
	var cards_to_remove = weapons_container.get_children().filter(func(c: ItemCard): 
		return c.item.item_name == clicked_weapon.item_name).slice(0,2)
		
		
	if weapons_to_remove.size() < 2 or cards_to_remove.size() < 2:
		return
	
	## Delete Weapons
	for weapon: Weapon in weapons_to_remove:
		Global.player.current_weapons.erase(weapon)
		Global.equipped_weapon.erase(weapon.data)
		
		weapon.queue_free()
		
	## Delete Cards
	for card: ItemCard in cards_to_remove:
		card.queue_free()
	
	## Create new weapons
	var upgraded_weapon: ItemWeapon = load(clicked_weapon.upgrade_to.resource_path)
	Global.player.add_weapon(upgraded_weapon)
	Global.equipped_weapon.append(upgraded_weapon)
	
	
	## Create new Item Card
	var new_card = create_item_card()
	weapons_container.add_child(new_card)
	new_card.item = upgraded_weapon
	
	context_card = null
	


func _on_sell_button_pressed() -> void:
	if not context_card:
		return
	SoundManager.play_sound(SoundManager.Sound.UI)
	var clicked_weapon = context_card.item as ItemWeapon
	var coins = clicked_weapon.item_cost * 0.75
	
	var weapon_to_remove: Weapon = Global.player.current_weapons.filter(func(w: Weapon):
		return w.data.item_name == clicked_weapon.item_name).front()
		
	if weapon_to_remove:
		Global.player.current_weapons.erase(weapon_to_remove)
		Global.equipped_weapon.erase(weapon_to_remove.data)
		weapon_to_remove.queue_free()
		
	context_card.queue_free()
	context_card = null
	
	
	Global.coin += coins 
