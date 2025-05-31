extends Control


@export var scoreboard_item_holder: VBoxContainer

const SCOREBOARD_ITEM_UID := "uid://cp8t06q6qfma6"


func _ready() -> void:
	# Getting the scores from ScoreboardManager
	var scores := ScoreboardManager.Scores
	if scores == null: return
	
	# Sorting scores according to the high score TODO: Make player able to choose which to sort with
	scores.sort_custom(func(a: Dictionary, b: Dictionary):
		return a.get(ScoreboardManager.SCORE_KEY, 0) > b.get(ScoreboardManager.SCORE_KEY, 0)
	)
	
	# Instantiating the scoreboard items and adding them to the holder
	for i in scores.size():
		var score_data = scores[i]
		
		var item: ScoreboardItem = load(SCOREBOARD_ITEM_UID).instantiate()
		if item == null: return
		
		scoreboard_item_holder.add_child(item)
		item.set_data(i + 1, score_data)
