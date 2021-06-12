extends Node2D

onready var input = $Input
onready var p1 = $Pattern1
onready var p2 = $Pattern2
onready var p3 = $Pattern3
onready var output = $Output


func _ready():
	p1.set_wave(1)
	p2.set_wave(2)
	p3.set_wave(3)
