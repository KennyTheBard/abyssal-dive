extends Node2D

export (String) var elementName

onready var move_tween: Tween = $MoveTween

func _ready():
	pass

func move_to(dest: Vector2, duration: float):
	move_tween.interpolate_property(self, "position", position, dest, duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	move_tween.start()


func fall_to(dest: Vector2, duration: float, delay: float):
	move_tween.interpolate_property(self, "position", position, dest, duration, Tween.TRANS_CUBIC, Tween.EASE_IN, delay)
	move_tween.start()
