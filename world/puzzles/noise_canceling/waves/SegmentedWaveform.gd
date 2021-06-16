extends Node2D

signal match_complete

const line_texture = preload("res://assets/sprites/signal/SignalWaveformTexture.png")

export (int) var num_points = 512
export (float) var width = 640
export (float) var amplitude = 35

onready var linesContainer: Node = $Lines

var values = [] setget set_values
var correct_values = []
var lines = []


func _ready():
	$Grid.size = Vector2(width, amplitude)


func set_values(new_values):
	values = new_values
	compute_waveform()


func compute_waveform():
	# empty the lines container
	for c in linesContainer.get_children():
		linesContainer.remove_child(c)
		c.queue_free()
	
	# draw the segments
	var correct_segment = abs(values[0] - correct_values[0]) < 0.05
	var line = create_line(correct_segment)
	for i in num_points:
		var delta = i / float(num_points)
		var point = Vector2(lerp(0, width, i / float(num_points)), lerp(0, amplitude, values[i]))
		line.add_point(point)
		
		# start new segment
		if correct_segment != (abs(values[i] - correct_values[i]) < 0.05):
			correct_segment = !correct_segment
			line = create_line(correct_segment)
			line.add_point(point)
	
	if correct_segment == true && linesContainer.get_child_count() == 1:
		emit_signal("match_complete")


func create_line(correct: bool):
	var line = Line2D.new()
	line.texture = line_texture
	line.texture_mode = Line2D.LINE_TEXTURE_TILE
	line.joint_mode = Line2D.LINE_JOINT_ROUND
	if correct:
		line.default_color = Color(0.0, 1.0, 0.0, 1.0)
	else:
		line.default_color = Color(1.0, 0.0, 0.0, 1.0)
	linesContainer.add_child(line)
	return line
