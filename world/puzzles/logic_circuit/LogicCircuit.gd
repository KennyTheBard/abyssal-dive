extends Node2D


func _ready():
	pass


func loadLevelData():
	var dict = {}
	var file = File.new()
	file.open("user://panelText.json", file.READ)
	dict.parse_json(file.get_as_text())
	file.close()
	
	# Test
	print(dict["text_1"])
