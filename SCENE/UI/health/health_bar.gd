#extends Control
#class_name HealthBar
#
#@onready var progress_bar: ProgressBar = $ProgressBar 
#@onready var health_lable: Label = $HealthAmount
#
#
#@export var back_color: Color
#@export var fill_color: Color
#
#
#func _ready() -> void:
	#var back_style = progress_bar.get_theme_stylebox("background").duplicate()
	#back_style.bg_color = back_color
	#var fill_style = progress_bar.get_theme_stylebox("fill").duplicate()
	#fill_style.bg_color = fill_color
	#
	#progress_bar.add_theme_stylebox_override("background",back_style)
	#progress_bar.add_theme_stylebox_override("fill", fill_style )
#
#
#func update_bar(value :float, health: float):
	#progress_bar.value = value 
	#health_lable.text = str(health)
#
#
#func _on_health_components_on_health_changed(current: float, max: float) -> void:
	#var value = current / max
	#update_bar(value, current)



extends Control
class_name HealthBar

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var health_lable: Label = $HealthAmount
@onready var hide_timer: Timer = $HideTimer

@export var back_color: Color
@export var fill_color: Color


func _ready() -> void:
	visible = false
	
	var back_style = progress_bar.get_theme_stylebox("background").duplicate()
	back_style.bg_color = back_color

	var fill_style = progress_bar.get_theme_stylebox("fill").duplicate()
	fill_style.bg_color = fill_color

	progress_bar.add_theme_stylebox_override("background", back_style)
	progress_bar.add_theme_stylebox_override("fill", fill_style)


func update_bar(value: float, health: float):
	progress_bar.value = value
	health_lable.text = str(health)


func _on_health_components_on_health_changed(current: float, max: float) -> void:
	var value = current / max
	update_bar(value, current)

	# Show bar and reset hide timer
	visible = true
	hide_timer.start()


func _on_hide_timer_timeout() -> void:
	visible = false
