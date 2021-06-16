extends Node2D

onready var dialog = $Dialog
onready var main_content = $MSContainer/MainScreen/Content
onready var sonar = $SonarContainer/Sonar/Sonar

var current_line = 0


var dialog_lines = [
	"Welcome aboard Neptune, captain Rodimus! Me and the crew are glad to have you on this expedition.",
	"We all heard stories about your exploits across the arctic ocean.",
	"You will meet the rest of the crew soon, but until then, let me show you to your post.",
	"This is the control panel of the submarine. From here, you can operate everything aboard Neptune.",
	"Lets make a test run, so you can familiarize yourself with station. No worries, it's easier than it seems.",
	"Firstly, lets check the engines.",
	"The nuclear reactor feeds power directly to the turbine, but you can force a bit more power if you wish.",
	"This is done by manually selecting the best atoms to be fissured inside the reactor. Please try to align 3 of those.",
	"Some may even cause chain reactions, triggering other atoms to fissure! Those give more power to the engines.",
	"Forcing power to the engine may cause a bit of overheating on our cooling system, but nothing to worry.",
	"You can redirect the heat inside the pipes to a cooling vent. Please, try to adjust the position of a pipe.",
	"Sometimes, the stress, heat and pressure may cause malfunctions on various systems.",
	"In this case, you can restart them manually by sending a full signal throught their circuit.",
	"Try setting the inputs from down there in order to have all outputs from up there set to 'OK'.",
	"This should restart them.",
	"While submerged, the communication with the surface control points will be affected.",
	"The ambiental noise of the ocean may change the signal, so we will need to filter it out.",
	"Try matching the first signal so that noise can be eliminated from the signal.", 
	"Last signal is the sum of the 3 from the middle. A segment is green when it matches the first waveform.",
	"Very good! Now lets procede with the safety manual...",
	"What? The sonar picked something. But it cannot be! We should already be deeper than any submarine can go.",
	"And it's closing it fast... I don't like this. Captain, we should put some distance between us and that thing."
]
var show_nuclear_reactor = 6
var test_nuclear_reactor = 8
var show_cooling_system = 10
var test_cooling_system = 11
var show_logic_circuit = 12
var test_logic_circuit = 14
var show_noise_canceling = 16
var test_noise_canceling = 19
var show_danger_sonar = 20


func _ready():
	play_tutorial()
	main_content.display_content("StandBy")


func play_tutorial():
	if current_line < dialog_lines.size():
		dialog.show_dialog("crewmate", dialog_lines[current_line])
		current_line += 1


func _on_Dialog_finished_line():
	# tutorial nuclear fision
	if current_line == show_nuclear_reactor:
		main_content.display_content("NuclearFusion")
	if current_line == test_nuclear_reactor:
		return
	
	# tutorial cooling system
	if current_line == show_cooling_system:
		main_content.display_content("CoolingSystem")
	if current_line == test_cooling_system:
		return
		
	# tutorial logic circuit
	if current_line == show_logic_circuit:
		main_content.display_content("LogicCircuit")
	if current_line == test_logic_circuit:
		return
	
	# tutorial noise cancelling
	if current_line == show_noise_canceling:
		main_content.display_content("NoiseCanceling")
	if current_line == test_noise_canceling:
		return
	
	if current_line == show_danger_sonar:
		sonar.spawn_danger()
	
	play_tutorial()


func _on_NuclearFusion_scored_points():
	if current_line == test_nuclear_reactor:
		play_tutorial()


func _on_CoolingSystem_rotated_pipe():
	if current_line == test_cooling_system:
		play_tutorial()


func _on_LogicCircuit_completed():
	if current_line == test_logic_circuit:
		play_tutorial()


func _on_NoiseCanceling_completed():
	if current_line == test_noise_canceling:
		play_tutorial()
