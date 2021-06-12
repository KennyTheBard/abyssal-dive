extends Node2D

enum Wave {
	Zero = 0,
	Sin = 1,
	Cos = 2,
	Square = 3
}

export (int) var num_points = 512
export (float) var width = 640
export (float) var amplitude = 35
export (int) var fq = 2 setget set_fq

onready var line : Line2D = $Line2D
onready var label : Label = $ValueLabel
onready var up_button : TextureButton = $UpFqButton
onready var down_button : TextureButton = $DownFqButton

var values = []
var wave = Wave.Zero


func _ready():
	$UpFqButton.connect("pressed", self, "_raise_fq")
	$DownFqButton.connect("pressed", self, "_lower_fq")
	
	set_wave(Wave.Zero)


func set_fq(new_fq: int):
	fq = new_fq
	label.text = str(fq)
	up_button.disabled = fq == 16
	down_button.disabled = fq == 1
	compute_waveform()


func set_wave(newWave: int):
	wave = newWave
	compute_waveform()


func get_wave_value(delta: float) -> float:
	match wave:
		Wave.Sin:
			return fn_sin(delta)
		Wave.Cos:
			return fn_cos(delta)
		Wave.Square:
			return fn_square(delta)
		_:
			return fn_zero(delta)


func compute_waveform():
	values.clear()
	line.clear_points()
	for i in num_points:
		var delta = i / float(num_points)
		var value = get_wave_value(delta)
		values.append(value)
		line.add_point(Vector2(lerp(0, width, i / float(num_points)), lerp(0, amplitude, value)))


func fn_zero(d: float) -> float:
	return 0.0


func fn_sin(d: float) -> float:
	return sin(lerp(0, 2 * PI * fq, d))


func fn_cos(d: float) -> float:
	return cos(lerp(0, 2 * PI * fq, d))


func fn_square(d: float):
	return sign(sin(2 * PI * d * fq))


func _raise_fq():
	if fq < 16:
		set_fq(fq * 2)


func _lower_fq():
	if fq > 1:
		set_fq(fq / 2)
