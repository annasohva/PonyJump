class_name ScoreboardManager extends Node


const SAVE_PATH: String = "user://save.dat"
const TIME_SEC_KEY: String = "t"
const SCORE_KEY: String = "s"
const FAULTS_KEY: String = "f"

static var Scores: Array[Dictionary] = []:
	get:
		# If we already fetched Scores during this run we return it
		if Scores.size() > 0: return Scores
		
		# Opening the save and checking if it's null
		var save := FileAccess.open(SAVE_PATH, FileAccess.READ)
		if save == null: return Scores
		
		# Getting scores from the save
		Scores = save.get_var()
		save.close()
		
		# Returning scores
		return Scores
	
	set(value):
		Scores = value


func _enter_tree() -> void:
	EventSystem.SCO_record_score.connect(record_score)


func record_score(time_sec: int, score: int, faults: int) -> void:
	# Adding the score to the Scores Array
	Scores.append({ TIME_SEC_KEY : time_sec, SCORE_KEY : score, FAULTS_KEY : faults})
	
	# Opening save file and saving the scores array
	var save := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	save.store_var(Scores)
	save.close()
