extends Node2D


export (Vector2) var size = Vector2(100, 100) setget set_size


func set_size(new_size: Vector2):
	size = new_size
	for c in get_children():
		var line: Line2D = c
		var new_points = []
		for p in line.points:
			new_points.push_back(Vector2(p.x * size.x/100, p.y * size.y/100))
		line.points = new_points
