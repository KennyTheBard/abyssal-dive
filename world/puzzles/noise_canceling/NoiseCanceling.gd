extends Node2D

signal completed

onready var input = $Input
onready var p1 = $Pattern1
onready var p2 = $Pattern2
onready var p3 = $Pattern3
onready var output = $Output


func _ready():
	p1.set_wave(randi() % 4 + 1)
	p2.set_wave(randi() % 4 + 1)
	p3.set_wave(randi() % 4 + 1)
	
#	var correct_values = calculate_values(randi() % p1.max_fq + 1, randi() % p1.max_fq + 1, randi() % p1.max_fq + 1)
	var correct_values = calculate_values(2, 3, 4)
	input.values = correct_values
	output.correct_values = correct_values
	
	p1.connect("waveform_changed", self, "_update_output")
	p2.connect("waveform_changed", self, "_update_output")
	p3.connect("waveform_changed", self, "_update_output")
	
	output.set_values(merge_values())


func _update_output():
	output.set_values(merge_values())


func merge_values():
	var values = []
	var current_value
	for idx in p1.values.size():
		current_value = (p1.values[idx] + p2.values[idx] + p3.values[idx]) / 3
		values.push_back(current_value)
	return values


func calculate_values(fq1: float, fq2: float, fq3: float):
	var values = []
	for i in p1.num_points:
		var delta = i / float(p1.num_points)
		var value1 = WaveMath.get_wave_value(p1.wave, delta, fq1)
		var value2 = WaveMath.get_wave_value(p2.wave, delta, fq2)
		var value3 = WaveMath.get_wave_value(p3.wave, delta, fq3)
		var value = (value1 + value2 + value3) / 3
		values.append(value)
	return values


func _on_Output_match_complete():
	emit_signal("completed")
