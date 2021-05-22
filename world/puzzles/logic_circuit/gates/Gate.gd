extends Node2D
class_name Gate

# Gate will emit a signal every time its internal state is changed
signal activated
signal deactivated

onready var logic: Node = $Logic

onready var i1: GateInput = $Inputs/I1
onready var i2: GateInput = $Inputs/I2
onready var i3: GateInput = $Inputs/I3
onready var i4: GateInput = $Inputs/I4

var i1_activated: bool = false setget set_i1_activated
var i2_activated: bool = false setget set_i2_activated
var i3_activated: bool = false setget set_i3_activated 
var i4_activated: bool = false setget set_i4_activated

var activated: bool = false setget set_activated


func _ready():
	i1_activated = i1.activated
	i1.connect("activated", self, "_on_i1_activated")
	i1.connect("deactivated", self, "_on_i1_deactivated")
	
	i2_activated = i2.activated
	i2.connect("activated", self, "_on_i2_activated")
	i2.connect("deactivated", self, "_on_i2_deactivated")
	
	i3_activated = i3.activated
	i3.connect("activated", self, "_on_i3_activated")
	i3.connect("deactivated", self, "_on_i3_deactivated")
	
	i4_activated = i4.activated
	i4.connect("activated", self, "_on_i4_activated")
	i4.connect("deactivated", self, "_on_i4_deactivated")


func set_activated(new_activated: bool):
	activated = new_activated
	
	if activated:
		emit_signal("activated")
	else:
		emit_signal("deactivated")

func set_i1_activated(new_activated: bool):
	i1_activated = new_activated
	activated = logic.apply(i1_activated, i2_activated, i3_activated, i4_activated)

func set_i2_activated(new_activated: bool):
	i2_activated = new_activated
	activated = logic.apply(i1_activated, i2_activated, i3_activated, i4_activated)

func set_i3_activated(new_activated: bool):
	i3_activated = new_activated
	activated = logic.apply(i1_activated, i2_activated, i3_activated, i4_activated)

func set_i4_activated(new_activated: bool):
	i4_activated = new_activated
	activated = logic.apply(i1_activated, i2_activated, i3_activated, i4_activated)

func _on_i1_activated():
	i1_activated = true

func _on_i1_deactivated():
	i1_activated = false

func _on_i2_activated():
	i2_activated = true

func _on_i2_deactivated():
	i2_activated = false

func _on_i3_activated():
	i3_activated = true

func _on_i3_deactivated():
	i3_activated = false

func _on_i4_activated():
	i4_activated = true

func _on_i4_deactivated():
	i4_activated = false
