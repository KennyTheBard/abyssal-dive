extends Node2D

enum Wave {
	Zero = 0,
	Sin = 1,
	Step = 2
}

export (int) var num_points = 512
export (float) var width = 640
export (float) var amlitude = 250
export (int) var fq = 2 setget set_fq

onready var line : Line2D = $Line2D

var points = []
var wave = Wave.Zero

func _ready():
	set_fq(4)


func set_fq(new_fq: int):
	fq = new_fq
	compute_waveform()


func set_wave(newWave: int):
	wave = newWave
	compute_waveform()


func get_wave_value(delta: float) -> float:
	match wave:
		Wave.Sin:
			return fn_sin(delta)
		Wave.Step:
			return fn_step(delta)
		_:
			return fn_zero(delta)


func compute_waveform():
	points.clear()
	line.clear_points()
	for i in num_points:
		var delta = i / float(num_points)
		var value = get_wave_value(delta)
		points.append(value)
		line.add_point(Vector2(lerp(0, width, i / float(num_points)), lerp(0, amlitude, value)))


# Wave function
func fn_sin(d: float) -> float:
	return sin(lerp(0, 2 * PI * fq, d))


# Step function
func fn_step(d: float) -> float:
	var sin_value = sin(lerp(0, 2 * PI * fq, d))
	if sin_value > 0.0:
		return 1.0
	else:
		return -1.0


# Zero function
func fn_zero(d: float) -> float:
	return 0.0

# Step functions
#func fn_spike(d: float):
#	var new_d = d * fq
#	var min_i = floor(new_d)
#	var max_i = ceil(new_d)
#	if new_d - min_i <= 0.25 && new_d - min_i > 0.75:
