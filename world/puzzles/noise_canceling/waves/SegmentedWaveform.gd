extends Node2D

const line_texture = preload("res://assets/sprites/signal/SignalWaveformTexture.png")

export (int) var num_points = 512
export (float) var width = 640
export (float) var amplitude = 35

var values = [] setget set_values
var lines = []

func set_values(new_values):
	values = new_values
#	compute_waveform()


#func compute_waveform():
#	line.clear_points()
#	for i in num_points:
#		var delta = i / float(num_points)
#		var value = values[i]
#		line.add_point(Vector2(lerp(0, width, i / float(num_points)), lerp(0, amplitude, value)))


func create_line(correct: bool):
	var line = Line2D.new()
	line.texture = line_texture
	line.texture_mode = Line2D.LINE_TEXTURE_TILE
	line.joint_mode = Line2D.LINE_JOINT_ROUND
	if correct:
		line.default_color = Color(0.0, 1.0, 0.0, 1.0)
	else:
		line.default_color = Color(1.0, 0.0, 0.0, 1.0)
