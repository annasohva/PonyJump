class_name ScoreboardItem extends Control


@onready var ranking_label: Label = $ScorePanel/HBoxContainer/RankingLabel
@onready var time_label: Label = $ScorePanel/HBoxContainer/TimeLabel
@onready var score_label: Label = $ScorePanel/HBoxContainer/ScoreLabel
@onready var faults_label: Label = $ScorePanel/HBoxContainer/FaultsLabel


func set_data(ranking: int, data: Dictionary):
	ranking_label.text = str(ranking)
	
	var seconds: int = data.get(ScoreboardManager.TIME_SEC_KEY, 0)
	var minutes := floori(seconds / 60.0)
	time_label.text = "%02d:%02d" % [minutes, seconds - minutes * 60]
	
	score_label.text = str(data.get(ScoreboardManager.SCORE_KEY, 0))
	faults_label.text = str(data.get(ScoreboardManager.FAULTS_KEY, 0))
