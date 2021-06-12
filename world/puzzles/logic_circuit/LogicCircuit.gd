extends Node2D

const levels_directory_path = "res://data/logic_circuit_levels"

onready var gates: Node = $Gates
onready var wires: Node = $Wires 

var gates_scene_dict = {
	"in": preload("res://world/puzzles/logic_circuit/gates/Input.tscn"),
	"out": preload("res://world/puzzles/logic_circuit/gates/Output.tscn"),
	"and": preload("res://world/puzzles/logic_circuit/gates/AndGate.tscn"),
	"or": preload("res://world/puzzles/logic_circuit/gates/OrGate.tscn"),
	"dup": preload("res://world/puzzles/logic_circuit/gates/Duplicator.tscn"),
	"not": preload("res://world/puzzles/logic_circuit/gates/Inverter.tscn")
}

var wire_scene = preload("res://world/puzzles/logic_circuit/gates/Wire.tscn")


func _ready():
	# load level
	var data = loadLevelData()
	buildLevel(data)


func buildLevel(data: Dictionary):
	# instantiate gates
	var gates_list = []
	for g in data.get("gates"):
		var gate_scene: PackedScene = gates_scene_dict.get(g.get("type"))
		var instance: Gate = gate_scene.instance()
		
		# set world parameters
		var gate_pos = g.get("position")
		instance.global_position = Vector2(gate_pos.get("x"), gate_pos.get("y"))
		instance.name = "Gate" + str(gates_list.size())
		
		gates_list.push_back(instance)
	
	# instantiate wires
	var wires_list = []
	for w in data.get("wires"):
		# prepare the wire instance
		var instance: Wire = wire_scene.instance()
		instance.name = "Wire" + str(wires_list.size())
		instance.src = gates_list[w.get("src")]
		instance.dst = gates_list[w.get("dst")]
		
		# bind the destination gate to the wire
		var dst_gate: Gate = gates_list[w.get("dst")]
		var dst_input = dst_gate.getFirstFreeInput()
		dst_gate.call("set", dst_input, instance)
		
		wires_list.push_back(instance)
	
	# add nodes to the scene
	for g in gates_list:
		gates.add_child(g)
	for w in wires_list:
		wires.add_child(w)
	
	# initialize nodes
	for w in wires_list:
		w.init()
	for g in gates_list:
		g.init()


func loadLevelData():
	var file = File.new()
	var level_path = chooseRandomLevel()
	file.open(level_path, file.READ)
	var dict = parse_json(file.get_as_text())
	file.close()
	return dict


func chooseRandomLevel():
	var level_paths = []
	var levels_dir = Directory.new()
	if levels_dir.open(levels_directory_path) == OK:
		levels_dir.list_dir_begin()
		var file_name = levels_dir.get_next()
		while not file_name.empty():
			if not levels_dir.current_is_dir():
				level_paths.push_back(file_name)
			file_name = levels_dir.get_next()
	else:
		push_error("Levels data directory is missing for logic circuit minigame")
	return levels_directory_path + "/" + level_paths[int(rand_range(0, level_paths.size()))]
