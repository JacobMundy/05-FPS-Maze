extends Control

var tempTime = 999999999999999

func _ready():
	for i in Global.scores:
		if int(tempTime) == 999999999999999:
			tempTime = i
		if int(Global.scores[i]) < int(Global.scores[tempTime]):
			tempTime = i
		$Scores.text += str(i) + ": " + Global.scores[i] + "	|	"
	if int(tempTime) != 999999999999999:
		$Scores/Label.text += str(tempTime) + ": " + str(Global.scores[tempTime])


func _on_Quit_pressed():
	get_tree().quit()
