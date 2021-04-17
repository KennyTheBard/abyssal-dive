extends Node2D

export (int) var width;
export (int) var height;
export (int) var x_start;
export (int) var y_start;
export (int) var offset;

export (float) var swap_time = 0.25
export (float) var fall_time = 0.5
export (float) var fall_delay = 0.25

onready var board = $Board
onready var selected_border = $SelectedBorder
onready var swap_timer: Timer = $SwapTimer

var pieces = [
	preload("res://world/puzzles/nuclear_fusion/atoms/Francium.tscn"),
	preload("res://world/puzzles/nuclear_fusion/atoms/Nobelium.tscn"),
	preload("res://world/puzzles/nuclear_fusion/atoms/Plutonium.tscn"),
	preload("res://world/puzzles/nuclear_fusion/atoms/Radium.tscn"),
	preload("res://world/puzzles/nuclear_fusion/atoms/Thorium.tscn"),
	preload("res://world/puzzles/nuclear_fusion/atoms/Uranium.tscn")
]

var all_pieces = []

var selection = null setget set_selection
var swap_first = null
var swap_last = null


func _ready():
	all_pieces = make_2d_array()
	init_grid()
	selected_border.visible = false
	swap_timer.connect("timeout", self, "_on_SwapTimer_timeout")


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
			
			while match_at(i, j, piece.elementName):
				rand = int(rand + 1) % pieces.size()
				piece = pieces[rand].instance()
			
			board.add_child(piece)
			piece.position = grid_to_pixel(i, j)
			all_pieces[i][j] = piece


func match_at(i, j, element):
	if i > 1:
		if all_pieces[i-1][j] != null && all_pieces[i-2][j] != null:
			if all_pieces[i-1][j].elementName == element && all_pieces[i-2][j].elementName == element:
				return true
				
	if j > 1:
		if all_pieces[i][j-1] != null && all_pieces[i][j-2] != null:
			if all_pieces[i][j-1].elementName == element && all_pieces[i][j-2].elementName == element:
				return true
	
	return false


func grid_to_pixel(column, row) -> Vector2:
	var new_x = x_start + offset * column
	var new_y = y_start - offset * row
	return Vector2(new_x, new_y)


func pixel_to_grid(pixel_x, pixel_y) -> Vector2:
	var new_x = round((pixel_x - x_start) / offset)
	var new_y = round((pixel_y - y_start) / -offset)
	return Vector2(new_x, new_y)


func swap_pieces(first: Vector2, second: Vector2, start_timer: bool = true):
	var first_pos = all_pieces[first.x][first.y].position
	var second_pos = all_pieces[second.x][second.y].position
	all_pieces[first.x][first.y].move_to(second_pos, swap_time)
	all_pieces[second.x][second.y].move_to(first_pos, swap_time)
	
	if start_timer:
		swap_timer.start(swap_time)
	
	var aux_piece = all_pieces[first.x][first.y]
	all_pieces[first.x][first.y] = all_pieces[second.x][second.y]
	all_pieces[second.x][second.y] = aux_piece


func fall_piece(grid_src: Vector2, grid_dest: Vector2):
	var pos = grid_to_pixel(grid_dest.x, grid_dest.y)
	all_pieces[grid_src.x][grid_src.y].fall_to(pos, fall_time, fall_delay)
	all_pieces[grid_dest.x][grid_dest.y] = all_pieces[grid_src.x][grid_src.y]
	all_pieces[grid_src.x][grid_src.y] = null


func set_selection(new_selection):
	if selection != null && new_selection == null:
		selected_border.visible = false
	elif selection == null && new_selection != null:
		selected_border.visible = true
	
	selection = new_selection
	if selection != null && all_pieces[selection.x][selection.y] != null:
		selected_border.position = all_pieces[selection.x][selection.y].position


func is_inside_grid(col, row):
	if col >= 0 && col < width:
		if row >= 0 && row < height:
			return true
	return false


func selection_input():
	if Input.is_action_just_pressed("select"):
		var pos = get_global_mouse_position()
		var grid_pos = pixel_to_grid(pos.x, pos.y)
		
		if is_inside_grid(grid_pos.x, grid_pos.y):
			if selection == null:
				set_selection(grid_pos)
			elif abs(grid_pos.x - selection.x) + abs(grid_pos.y - selection.y) > 1:
				set_selection(grid_pos)
			else:
				swap_pieces(selection, grid_pos)
				swap_first = selection
				swap_last = grid_pos
				set_selection(null)


func check_for_matches():
	var matches = []
	for i in width:
		for j in height:
			if all_pieces[i][j] != null:
				var element = all_pieces[i][j].elementName
				if i > 0 && i < width - 1:
					if all_pieces[i-1][j] != null && all_pieces[i+1][j]:
						if all_pieces[i-1][j].elementName == element && all_pieces[i+1][j].elementName == element:
							matches.append(Vector2(i-1, j))
							matches.append(Vector2(i, j))
							matches.append(Vector2(i+1, j))
				if j > 0 && j < height - 1:
					if all_pieces[i][j-1] != null && all_pieces[i][j+1]:
						if all_pieces[i][j-1].elementName == element && all_pieces[i][j+1].elementName == element:
							matches.append(Vector2(i, j-1))
							matches.append(Vector2(i, j))
							matches.append(Vector2(i, j+1))
	return matches


func score_matches() -> bool:
	var matches = check_for_matches()
	var deleted_pos = []
	for pos in matches:
		if all_pieces[pos.x][pos.y] != null:
			board.remove_child(all_pieces[pos.x][pos.y])
			all_pieces[pos.x][pos.y] = null
			deleted_pos.append(pos)
	refill_board(deleted_pos)
	return deleted_pos.size() > 0


func refill_board(deleted_pos: PoolVector2Array):
	for i in width:
		var count_empty = 0
		for j in height:
			if all_pieces[i][j] == null:
				count_empty += 1
			else:
				if count_empty > 0:
					fall_piece(Vector2(i, j), Vector2(i, j - count_empty))


func _process(delta):
	selection_input()


func _on_SwapTimer_timeout():
	if not score_matches():
		swap_pieces(swap_last, swap_first, false)
