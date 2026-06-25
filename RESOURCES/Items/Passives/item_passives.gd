extends ItemBase
class_name ItemPassives


@export var add_value: float
@export var add_stats: String
@export var remove_value: float
@export var remove_stats: String


func get_description() -> String:
	var description = "[code]"
	
	if add_value != 0:
		description += "[color=green]+%s %s[/color]\n" % [add_value, add_stats]
	
	description += "[/code]"
	
	if remove_value != 0:
		description += "[color=red]-%s %s[/color]" % [remove_value, remove_stats]
	
	return description


func apply_passive():
	if add_value != 0:
		Global.player.stats[add_stats] += add_value
		
	if remove_value != 0:
		Global.player.stats[remove_stats] -= remove_stats
