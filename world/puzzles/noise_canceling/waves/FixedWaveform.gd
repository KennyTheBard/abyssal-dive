extends Node2D

export (int) var num_points = 512
export (float) var width = 640
export (float) var amplitude = 35

onready var line : Line2D = $Line2D

var values = [] setget set_values


func set_values(new_values):
	values = new_values
	compute_waveform()


func compute_waveform():
	line.clear_points()
	for i in num_points:
		var delta = i / float(num_points)
		var value = values[i]
		line.add_point(Vector2(lerp(0, width, i / float(num_points)), lerp(0, amplitude, value)))

