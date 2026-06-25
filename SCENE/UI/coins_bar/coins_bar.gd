extends HBoxContainer
class_name CoinsBar

@onready var coins: Label = $Coins


func _process(delta: float) -> void:
	coins.text = str(Global.coin)
