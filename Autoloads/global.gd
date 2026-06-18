extends Node

signal on_create_block_text(unit: Node2D)
signal on_create_damage_text(unit: Node2D, hitbox: HitBoxComponents )

const FLASH_MATERIALS = preload("res://SCENE/Effects/flash_materials.tres")
const FLOATING_TEXT = preload("res://SCENE/UI/Floating_Text/floating_text.tscn")



enum UpgradeTier{
	COMMON,
	RARE,
	EPIC,
	LEGENDARY
}


var player: Player
var game_paused = false

func get_chance_success(chance: float) -> bool:
	var random = randf_range(0,1.0)
	if random < chance:
		return true
	return false
#func get_chance_success(chance):
	#var random = randf()
	#return random < chance
