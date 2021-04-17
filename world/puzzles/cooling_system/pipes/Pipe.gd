extends Node2D

onready var disconnected: Sprite = $Disconnected
onready var connected: Sprite = $Connected


func _ready():
	activate_connected(false)


func activate_connected(active: bool):
	if connected != null:
		connected.visible = active
