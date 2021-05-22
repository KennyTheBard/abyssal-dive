extends Node2D

export (NodePath) var src_path
var src = null

export (NodePath) var dst_path
var dst = null

onready var line: Line2D = $Line
onready var start: Position2D = $Start
onready var end: Position2D = $End

var activated: bool = false setget set_activated


func _ready():
	src = get_node(src_path)
	dst = get_node(dst_path)
	
	activated = src.activated
	src.connect("activated", self, "_on_source_activated")
	src.connect("deactivated", self, "_on_source_deactivated")
	
	draw_wire()


func draw_wire():
	line.clear_points()
	line.add_point(start.position)
	line.add_point(end.position)


func set_activated(new_activated: bool):
	activated = new_activated
	
	if activated:
		dst.activate()
	else:
		dst.deactivate()


func _on_source_activated():
	activated = true


func _on_source_deactivated():
	activated = false

