extends Node

signal finished_line

onready var rect: TextureRect = $TextureRect
onready var label: Label = $TextureRect/Label
onready var display_tween: Tween = $DisplayTween
onready var display_timer: Timer = $DisplayTimer

func _ready():
	clear_dialog()


func clear_dialog():
	rect.visible = false
	label.text = ""


func show_dialog(speaker: String, text: String):
	rect.visible = true
	label.percent_visible = 0
	label.text = speaker.to_upper() + ": " + text
	display_tween.interpolate_property(label, "percent_visible", 0.0, 1.0, 0.05 * label.text.length())
	display_tween.start()


func _on_DisplayTween_tween_all_completed():
	display_timer.start(1)


func _on_DisplayTimer_timeout():
	clear_dialog()
	emit_signal("finished_line")
