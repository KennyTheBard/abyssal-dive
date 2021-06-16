extends Label


export (String) var stand_by_message = "Stand by"
var num_dots = 0


func _on_Timer_timeout():
	num_dots = (num_dots + 1) % 4
	text = stand_by_message
	for i in range(num_dots):
		text += "."
