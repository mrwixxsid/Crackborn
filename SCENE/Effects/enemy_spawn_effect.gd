extends Sprite2D
class_name EnemySpawnerEffect


@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	anim_player.play("Spawn")
