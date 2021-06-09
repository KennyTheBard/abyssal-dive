extends Node2D
class_name Gate

signal status_changed(new_status)

export (NodePath) var input_1_path
var input_1 = null

export (NodePath) var input_2_path
var input_2 = null

export (NodePath) var input_3_path
var input_3 = null

export (NodePath) var input_4_path
var input_4 = null

onready var logic: Node = $Logic

var i1: bool = false setget set_i1
var i2: bool = false setget set_i2
var i3: bool = false setget set_i3
var i4: bool = false setget set_i4

var activated: bool = false setget set_activated


func _ready():
	input_1 = get_node(input_1_path)
	i1 = input_1.activated
	input_1.connect("status_changed", self, "_on_i1_status_changed")
	
	input_2 = get_node(input_2_path)
	i2 = input_2.activated
	input_2.connect("status_changed", self, "_on_i2_status_changed")
	
	input_3 = get_node(input_3_path)
	i3 = input_3.activated
	input_3.connect("status_changed", self, "_on_i3_status_changed")
	
	input_4 = get_node(input_4_path)
	i4 = input_4.activated
	input_4.connect("status_changed", self, "_on_i4_status_changed")


func set_activated(new_activated: bool):
	activated = new_activated
	emit_signal("status_changed", activated)


func set_i1(new_activated: bool):
	i1 = new_activated
	activated = logic.apply(i1, i2, i3, i4)


func set_i2(new_activated: bool):
	i2 = new_activated
	activated = logic.apply(i1, i2, i3, i4)


func set_i3(new_activated: bool):
	i3 = new_activated
	activated = logic.apply(i1, i2, i3, i4)


func set_i4(new_activated: bool):
	i4 = new_activated
	activated = logic.apply(i1, i2, i3, i4)


func _on_i1_status_changed(new_activated):
	i1 = new_activated


func _on_i2_status_changed(new_activated):
	i2 = new_activated


func _on_i3_status_changed(new_activated):
	i3 = new_activated


func _on_i4_status_changed(new_activated):
	i4 = new_activated
