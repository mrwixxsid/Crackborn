extends Node

signal on_create_block_text(unit: Node2D)
signal on_create_damage_text(unit: Node2D, hitbox: HitBoxComponents )


## GAME UPGRADE UI
signal on_upgrade_selected

signal on_create_heal_text(unit: Node2D, heal: float)

signal on_enemy_died(enemy: Enemy)

const FLASH_MATERIALS = preload("res://SCENE/Effects/flash_materials.tres")
const FLOATING_TEXT = preload("res://SCENE/UI/Floating_Text/floating_text.tscn")
const COINS_SCENE = preload("uid://jb6fqlf5dd2e")

const ITEM_CARD_SCENE = preload("uid://cex8x2g6uj6yr")


## UPGRADE CARD STYLE'S
const COMMON_STYLE = preload("uid://btkdo13npucia")
const RARE_STYLE = preload("uid://bcn83slev3wda")
const EPIC_STYLE = preload("uid://38wacatku1lq")
const LEGENDARY_STYLE = preload("uid://c5wnvswfkxaa4")





const UPGRADE_PROBABLITY_CONFIG = {
	"rare": {"start_wave": 2, "base_multi": 0.06 },
	"epic": {"start_wave": 4, "base_multi": 0.02 },
	"legendary": {"start_wave": 7, "base_multi": 0.6 },
}

const SHOP_PROBABLITY_CONFIG = {
	"rare": {"start_wave": 1, "base_multi": 0.10 },
	"epic": {"start_wave": 3, "base_multi": 0.06 },
	"legendary": {"start_wave": 7, "base_multi": 0.02 },
}

enum UpgradeTier{
	COMMON,
	RARE,
	EPIC,
	LEGENDARY
}


var coin: int = 300
var player: Player
var game_paused = false

var selected_weapon: ItemWeapon
var equipped_weapon: Array[ItemWeapon]

func get_harvesting_coin():
	coin += player.stats.hervesting

func get_chance_success(chance: float) -> bool:
	var random = randf_range(0,1.0)
	if random < chance:
		return true
		
	return false
#func get_chance_success(chance):
	#var random = randf()
	#return random < chance



func get_tier_style(tier: UpgradeTier):
	match tier:
		UpgradeTier.COMMON:
			return COMMON_STYLE
		UpgradeTier.RARE:
			return RARE_STYLE
		UpgradeTier.EPIC:
			return EPIC_STYLE
		UpgradeTier.LEGENDARY:
			return LEGENDARY_STYLE
	

func calculate_tier_probablity(current_wave: int, config: Dictionary) -> Array[float]:
	var common_chance = 0.0
	var rare_chance = 0.0
	var epic_chance = 0.0
	var legendary_chance = 0.0
	
	
	## RARE: Starts increasing from wave 2 (0% at wave 1)
	if current_wave >= config.rare.start_wave:
		rare_chance = min(1.0, (current_wave - 1) * config.rare.base_multi)
		print("Who the hell")
		print(rare_chance)
		
	## EPIC: Starts increasing from wave 4 (0% at wave 3)
	if current_wave >= config.epic.start_wave:
		epic_chance = min(1.0, (current_wave - 3) * config.epic.base_multi)
		
	## LEGENDARY: Starts increasing from wave 7 (0% at wave 6)
	if current_wave >= config.legendary.start_wave:
		legendary_chance = min(1.0, (current_wave - 6 ) * config.legendary.base_multi)
	
	## Player Luck increases the changes of finding higher Tier
	## EXAMPLE: 10 luck - 10% chance = 1.1 multi
	var luck_factor = 1.0 + (Global.player.stats.luck / 100.0)
	rare_chance *= luck_factor
	epic_chance *= luck_factor
	legendary_chance *= luck_factor
	
	## Normalize probablity
	var total_non_common_chances = rare_chance + epic_chance + legendary_chance
	## In case total is more than 100%, we normalize
	if total_non_common_chances > 1.0:
		var scale_down = 1.0 / total_non_common_chances
		rare_chance *= scale_down
		epic_chance *= scale_down
		legendary_chance *= scale_down
		total_non_common_chances = 1.0 
	
	
	## Common takes the remaining probablity
	common_chance = 1.0 - total_non_common_chances
	
	## Debug Print
	print("Wave:%d Luck:%.1f => C:%.4f R:%.4f E:%.4f L:%.4f" %
	[current_wave, Global.player.stats.luck, common_chance, rare_chance, epic_chance, legendary_chance])
	
	return [
		max(0.0, common_chance),
		max(0.0, rare_chance),
		max(0.0, epic_chance),
		max(0.0, legendary_chance),
		]
	
func select_item_for_offer(item_pool: Array, current_wave: int, config: Dictionary) -> Array:
		
## [0.7, 0.2, 0.08. 0.02]
	var tier_chances = calculate_tier_probablity(current_wave, config)
		
	var legendary_limit = tier_chances[3]
	var epic_limit = legendary_limit + tier_chances[2]
	var rare_limit = epic_limit + tier_chances[1]
	var common_limit = tier_chances[0]
	
	var offer_item: Array = []
	while offer_item.size() < 4:
		var roll = randf()
		var chosen_tier_index = 0
		
		
		if roll < legendary_limit:
			chosen_tier_index = 3    ##Legendary
		elif roll < epic_limit:
			chosen_tier_index = 2    ## Epic
		elif roll < rare_limit:
			chosen_tier_index = 1   ## Rare
		else:
			chosen_tier_index = 0
		
		var potential_items: Array = []
		var current_search_tier_index = chosen_tier_index
			
		while potential_items.is_empty() and current_search_tier_index >= 0:
			potential_items = item_pool.filter(func(item: ItemBase): return item.item_tier == current_search_tier_index)
			
			if potential_items.is_empty():
				current_search_tier_index -= 1
			else:
				break
		
		if not potential_items.is_empty():
			var selected_item = potential_items.pick_random()
			
			if not offer_item.has(selected_item):
				offer_item.append(selected_item)
	
	return offer_item
