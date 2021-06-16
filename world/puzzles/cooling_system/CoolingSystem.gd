extends Node2D

signal rotated_pipe

export (int) var width
export (int) var height
export (int) var x_start
export (int) var y_start
export (int) var offset

export (float) var rotate_time = 0.2

onready var pipe_container : Node2D = $PipeContainer
onready var rotation_timer : Timer = $RotationTimer
onready var update_heat_timer : Timer = $UpdateHeatTimer

var pipes = [
	preload("res://world/puzzles/cooling_system/pipes/LinePipe.tscn"),
	preload("res://world/puzzles/cooling_system/pipes/CurvePipe.tscn"),
	preload("res://world/puzzles/cooling_system/pipes/TeePipe.tscn"),
	preload("res://world/puzzles/cooling_system/pipes/PlusPile.tscn"),
	preload("res://world/puzzles/cooling_system/pipes/Cooler.tscn")
]

var pipe_rotation = [0.0, 90.0, 180.0, 270.0]
var board = []
var heat_source = null
var rotating : bool = false


func _ready():
	board = make_2d_array()
	init_grid()
	rotation_timer.connect("timeout", self, "_on_RotationTimer_timeout")



func make_2d_array():
	var array = [];
	for i in width:
		array.append([])
		for j in height:
			array[i].append(null)
	return array


func init_grid():
	# generate board of pipes
	# TODO: change the generation logic to make sure there is only
	# 		as many coolers as heat points and there is always
	#		a path between the former and teh later
	for i in width:
		for j in height:
			var pipe = pipes[floor(rand_range(0, pipes.size()))].instance()
			pipe.set_rotation_degrees(pipe_rotation[floor(rand_range(0, pipe_rotation.size()))])
			
			pipe_container.add_child(pipe)
			pipe.position = grid_to_pixel(i, j)
			board[i][j] = pipe
	
	# select a heat source
	while heat_source == null:
		var pos = Vector2(floor(rand_range(0, width)), floor(rand_range(0, height)))
		var rand_pipe = board[pos.x][pos.y]
		if not rand_pipe.is_cooler:
			heat_source = pos
			update_heat(pos)


func grid_to_pixel(column, row) -> Vector2:
	var new_x = x_start + offset * column
	var new_y = y_start - offset * row
	return Vector2(new_x, new_y)


func pixel_to_grid(pixel_x, pixel_y) -> Vector2:
	var new_x = round((pixel_x - x_start) / offset)
	var new_y = round((pixel_y - y_start) / -offset)
	return Vector2(new_x, new_y)


func is_inside_grid(col, row):
	if col >= 0 && col < width:
		if row >= 0 && row < height:
			return true
	return false


func rotate_pipe(grid_pos: Vector2):
	board[grid_pos.x][grid_pos.y].rotate_pipe(90, rotate_time)
	rotation_timer.start(rotate_time)
	emit_signal("rotated_pipe")


func update_heat(grid_pos: Vector2):
	var current_pipe = board[grid_pos.x][grid_pos.y]
	
	# find valid neighbouts
	var neighbours = []
	for con in current_pipe.get_connections():
		var next_grid_pos = Vector2(grid_pos.x + con.x, grid_pos.y + con.y)
		if is_inside_grid(next_grid_pos.x, next_grid_pos.y):
			var next_neighbour = board[next_grid_pos.x][next_grid_pos.y]
			for neigh_con in next_neighbour.get_connections():
				if neigh_con == -con:
					neighbours.append(next_grid_pos)
	
	# check if conducting heat
	current_pipe.conducting_heat = grid_pos == heat_source
	for neigh in neighbours:
		var neigh_pipe = board[neigh.x][neigh.y]
		if neigh_pipe.conducting_heat:
			current_pipe.conducting_heat = true
	current_pipe.set_conducting_heat(current_pipe.conducting_heat)

	# if conducting heat, update neighbours that are not conducting heat
	if current_pipe.conducting_heat:
		for neigh in neighbours:
			var neigh_pipe = board[neigh.x][neigh.y]
			if not neigh_pipe.conducting_heat:
				update_heat(neigh)


func selection_input():
	if Input.is_action_just_pressed("select") && not rotating:
		var pos = get_local_mouse_position()
		var grid_pos = pixel_to_grid(pos.x, pos.y)
		
		if is_inside_grid(grid_pos.x, grid_pos.y):
			rotating = true
			rotate_pipe(grid_pos)


func _process(delta):
	selection_input()


func _on_RotationTimer_timeout():
	# deactivate all pipes
	for i in width:
		for j in height:
			board[i][j].set_conducting_heat(false)
	update_heat(heat_source)
	rotating = false
