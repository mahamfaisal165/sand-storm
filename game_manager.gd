extends Node

# Typo fixed: changed 'scoure_label' to 'score_label'
@onready var score_labe: Label = $"CanvasLayer/score labe"

var score = 0 

func add_point():
	score += 1
	# Removed the extra colon ':' at the end of the line
	score_labe.text = "Bottle Collected: " + str(score)
