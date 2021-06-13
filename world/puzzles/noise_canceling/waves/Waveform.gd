extends Node2D

signal waveform_changed

export (int) var num_points = 512
export (float) var width = 640
export (float) var amplitude = 35
export (int) var fq = 2 setget set_fq
export (int) var max_fq = 10

onready var line : Line2D = $Line
onready var label : Label = $ValueLabel
onready var up_button : TextureButton = $UpFqButton
onready var down_button : TextureButton = $DownFqButton

var values = []
var wave = WaveMath.Zero


func _ready():
	$Grid.size = Vector2(width, amplitude)
	
	$UpFqButton.connect("pressed", self, "_raise_fq")
	$DownFqButton.connect("pressed", self, "_lower_fq")
	
	set_wave(WaveMath.Zero)


func set_fq(new_fq: int):
	fq = new_fq
	label.text = str(fq)
	up_button.disabled = fq == max_fq
	down_button.disabled = fq == 1
	compute_waveform()
	emit_signal("waveform_changed")


func set_wave(newWave: int):
	wave = newWave
	compute_waveform()


func compute_waveform():
	values.clear()
	line.clear_points()
	for i in num_points:
		var delta = i / float(num_points)
		var value = WaveMath.get_wave_value(wave, delta, fq)
		values.append(value)
		line.add_point(Vector2(lerp(0, width, i / float(num_points)), lerp(0, amplitude, value)))


func _raise_fq():
	if fq < max_fq:
		set_fq(fq + 1)


func _lower_fq():
	if fq > 1:
		set_fq(fq - 1)
