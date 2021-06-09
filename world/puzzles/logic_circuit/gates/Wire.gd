extends Node2D
class_name Wire

signal status_changed(new_status)

export (NodePath) var src_path
var src = null

onready var line: Line2D = $Line
onready var start: Position2D = $Start
onready var end: Position2D = $End

var activated: bool = false setget set_activated


func _ready():
	src = get_node(src_path)
	
	activated = src.activated
	src.connect("status_changed", self, "_on_source_status_changed")
	src.connect("deactivated", self, "_on_source_deactivated")
	
	draw_wire()


func draw_wire():
	line.clear_points()
	line.add_point(start.position)
	line.add_point(end.position)


func set_activated(new_activated: bool):
	activated = new_activated
	emit_signal("status_changed", activated)


func _on_source_status_changed(new_activated):
	activated = new_activated


