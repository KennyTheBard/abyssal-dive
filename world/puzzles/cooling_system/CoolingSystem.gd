extends Node2D

export (int) var width;
export (int) var height;
export (int) var x_start;
export (int) var y_start;
export (int) var offset;

onready var pipe_container : Node2D = $PipeContainer

var pipes = [
	preload("res://world/puzzles/cooling_system/pipes/LinePipe.tscn"),
	preload("res://world/puzzles/cooling_system/pipes/CurvePipe.tscn"),
	preload("res://world/puzzles/cooling_system/pipes/TeePipe.tscn"),
	preload("res://world/puzzles/cooling_system/pipes/PlusPile.tscn"),
	preload("res://world/puzzles/cooling_system/pipes/Cooler.tscn")
]

var pipe_rotation = [0.0, 90.0, 180.0, 270.0]

var board = []

func _ready():
	board = make_2d_array()
	init_grid()


func make_2d_array():
	var array = [];
	for i in width:
		array.append([])
		for j in height:
			array[i].append(null)
	return array


func init_grid():
	for i in width:
		for j in height:
			var pipe = pipes[floor(rand_range(0, pipes.size()))].instance()
			pipe.set_rotation_degrees(pipe_rotation[floor(rand_range(0, pipe_rotation.size()))])
			
			pipe_container.add_child(pipe)
			pipe.position = grid_to_pixel(i, j)
			board[i][j] = pipe


func grid_to_pixel(column, row) -> Vector2:
	var new_x = x_start + offset * column
	var new_y = y_start - offset * row
	return Vector2(new_x, new_y)


func pixel_to_grid(pixel_x, pixel_y) -> Vector2:
	var new_x = round((pixel_x - x_start) / offset)
	var new_y = round((pixel_y - y_start) / -offset)
	return Vector2(new_x, new_y)
