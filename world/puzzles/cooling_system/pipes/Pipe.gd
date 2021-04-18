extends Node2D

export (bool) var connect_up
export (bool) var connect_right
export (bool) var connect_down
export (bool) var connect_left
export (bool) var is_cooler

onready var disconnected: Sprite = $Disconnected
onready var connected: Sprite = $Connected
onready var rotation_tween: Tween = $RotationTween
onready var debug_label: Label = $DebugLabel

var conducting_heat: bool = false setget set_conducting_heat
var heat_distance = INF


func _ready():
	set_conducting_heat(false)


func set_conducting_heat(active: bool):
	conducting_heat = active
	if connected != null:
		connected.visible = active


func rotate_pipe(degrees: float, duration: float):
	rotation_tween.interpolate_property(self, "rotation", rotation, rotation + deg2rad(degrees), duration, Tween.TRANS_CIRC)
	rotation_tween.start()


func get_connections() -> PoolVector2Array:
	var rotation_index = int(round(rotation_degrees / 90)) % 4
	var connections = []
	var positions = [Vector2(0, 1), Vector2(1, 0), Vector2(0, -1), Vector2(-1, 0)]
	if connect_up:
		connections.append(positions[(0 + rotation_index) % positions.size()])
	if connect_right:
		connections.append(positions[(1 + rotation_index) % positions.size()])
	if connect_down:
		connections.append(positions[(2 + rotation_index) % positions.size()])
	if connect_left:
		connections.append(positions[(3 + rotation_index) % positions.size()])
	return connections
