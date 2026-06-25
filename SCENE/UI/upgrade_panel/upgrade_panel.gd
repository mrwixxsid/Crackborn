extends Panel
class_name Upgrade_Panel
 


const UPGRADE_CARD_SCENE = preload("res://SCENE/UI/upgrade_card/upgrade_card.tscn")


@export var upgrade_list: Array[ItemUpgrade]

@onready var items_container: HBoxContainer = %ItemsContainer



	
	

func load_upgrade(current_wave: int):
	for child in items_container.get_children():
		child.queue_free()
		
	var config = Global.UPGRADE_PROBABLITY_CONFIG
	var selected_upgrades = Global.select_item_for_offer(upgrade_list, current_wave, config)
	for random_upgrade: ItemUpgrade in selected_upgrades:
		var card_instance = UPGRADE_CARD_SCENE.instantiate() as UpgradeCard
		items_container.add_child(card_instance)
		card_instance.item_data = random_upgrade   

#func load_upgrade():
	#for child in items_container.get_children():
		#child.queue_free()
#
	#var available_upgrades = upgrade_list.duplicate()
	#available_upgrades.shuffle()
#
	#for i in min(4, available_upgrades.size()):
		#var card_instance = UPGRADE_CARD_SCENE.instantiate() as UpgradeCard
		#items_container.add_child(card_instance)
		#card_instance.item_data = available_upgrades[i]
