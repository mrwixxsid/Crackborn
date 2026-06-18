extends Panel
class_name StatsContainer


##Lables
@onready var health_lable: Label = %HealthLable
@onready var hp_regen_lable: Label = %HP_regen_Lable
@onready var life_steal_lable: Label = %Life_steal_Lable
@onready var damage_lable: Label = %Damage_Lable
@onready var luck_lable: Label = %Luck_Lable
@onready var speed_lable: Label = %Speed_Lable
@onready var block_lable: Label = %Block_Lable
@onready var hervest_lable: Label = %Hervest_Lable


func _process(delta: float) -> void:
	if not is_instance_valid(Global.player):
		return
	health_lable.text = str(Global.player.stats.health)
	hp_regen_lable.text = str(Global.player.stats.hp_regen)
	life_steal_lable.text = str(Global.player.stats.life_steal) + "%"
	damage_lable.text = str(Global.player.stats.damage)
	luck_lable.text = str(Global.player.stats.luck)
	speed_lable.text = str(Global.player.stats.speed)
	block_lable.text = str(Global.player.stats.block_chance) + "%"
	hervest_lable.text = str(Global.player.stats.hervesting)
