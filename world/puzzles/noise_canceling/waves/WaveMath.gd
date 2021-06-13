extends Node

class_name WaveMath

enum {
	Zero = 0,
	Sin = 1,
	Cos = 2,
	Square = 3,
	Ramp = 4
}

static func get_wave_value(wave: int, delta: float, fq: float) -> float:
	match wave:
		Sin:
			return fn_sin(delta, fq)
		Cos:
			return fn_cos(delta, fq)
		Square:
			return fn_square(delta, fq)
		Ramp:
			return fn_ramp(delta, fq)
		_:
			return fn_zero(delta, fq)


static func fn_zero(d: float, fq: float) -> float:
	return 0.0


static func fn_sin(d: float, fq: float) -> float:
	return sin(lerp(0, 2 * PI * fq, d))


static func fn_cos(d: float, fq: float) -> float:
	return cos(lerp(0, 2 * PI * fq, d))


static func fn_square(d: float, fq: float):
	return sign(sin(2 * PI * d * fq))


static func fn_ramp(d: float, fq: float):
	return 1 - 2 * abs(fmod(d * fq * 2, 1.0) - 1)
