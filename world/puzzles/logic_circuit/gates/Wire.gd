extends Node2D
class_name Wire

signal status_changed(new_status)

var src = null
var dst = null

onready var line: Line2D = $Line
onready var start: Vector2 = Vector2()
onready var end: Vector2 = Vector2()

var activated: bool = false setget set_activated


func init():
	start = src.position
	end = dst.position
	activated = src.activated
	src.connect("status_changed", self, "_on_source_status_changed")
	
	draw_wire()


func draw_wire():
	line.clear_points()
	line.add_point(start)
	
	# add middle points
	for c in get_children():
		if c is Position2D:
			line.add_point(c.global_position)
	
	line.add_point(end)


func set_activated(new_activated: bool):
	activated = new_activated
	emit_signal("status_changed", activated)


func _on_source_status_changed(new_activated):
	set_activated(new_activated)



