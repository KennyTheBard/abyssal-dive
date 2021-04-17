extends Node2D

export (int) var width;
export (int) var height;
export (int) var x_start;
export (int) var y_start;
export (int) var offset;

var pieces = [
	preload("res://world/puzzles/nuclear_fusion/atoms/Francium.tscn"),
	preload("res://world/puzzles/nuclear_fusion/atoms/Nobelium.tscn"),
	preload("res://world/puzzles/nuclear_fusion/atoms/Plutonium.tscn"),
	preload("res://world/puzzles/nuclear_fusion/atoms/Radium.tscn"),
	preload("res://world/puzzles/nuclear_fusion/atoms/Thorium.tscn"),
	preload("res://world/puzzles/nuclear_fusion/atoms/Uranium.tscn")
]

var all_pieces = []

func _ready():
	all_pieces = make_2d_array()
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
			var rand = floor(rand_range(0, pieces.size()))
			var piece = pieces[rand].instance()
			add_child(piece)
			piece.position = grid_to_pixel(i, j)


func grid_to_pixel(column, row) -> Vector2:
	var new_x = x_start + offset * column
	var new_y = y_start - offset * row
	return Vector2(new_x, new_y)