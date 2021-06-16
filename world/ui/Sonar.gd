extends Node2D

const line_texture = preload("res://assets/sprites/signal/SignalWaveformTexture.png")
const dange_point_scene = preload("res://world/ui/DangerPoint.tscn")

onready var scan_line: Node2D = $ScanLine
onready var center: Node2D = $ScanLine/Center
onready var lines_container: Node2D = $LinesContainer
onready var danger_container: Node2D = $DangerContainer
onready var danger_pos_tween: Node2D = $DangerPositionTween

export (float) var rotation_spd_deg = 270 
export (float) var radius = 250 
export (float) var danger_hide_spd = 1.5 
export (int) var num_circles = 3

func _ready():
	for r in range(radius / num_circles, radius, radius / num_circles):
		var line = create_line()
		for a in range(0, 360, 3):
			line.add_point(Vector2(r * cos(deg2rad(a)), r * sin(deg2rad(a))))
		line.add_point(Vector2(r, 0))


func _process(delta):
	# rotate the scan line
	scan_line.rotation_degrees -= rotation_spd_deg * delta
	
	# hide the dangers
	for c in danger_container.get_children():
		c.modulate = Color(1, 1, 1, c.modulate.a - delta * (1 / danger_hide_spd))


func create_line():
	var line = Line2D.new()
	line.texture = line_texture
	line.texture_mode = Line2D.LINE_TEXTURE_TILE
	line.joint_mode = Line2D.LINE_JOINT_ROUND
	line.default_color = Color(0, 1, 0, 1)
	lines_container.add_child(line)
	return line


func _on_ScanLine_body_entered(body):
	body.modulate = Color(1, 1, 1, 1)


func spawn_danger():
	var danger = dange_point_scene.instance()
	danger.position = center.position + Vector2(275, 100)
	danger_pos_tween.interpolate_property(danger, "position", danger.position, center.position, 20)
	danger_pos_tween.start()
	danger_container.add_child(danger)
