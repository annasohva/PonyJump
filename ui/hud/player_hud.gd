extends Control


@onready var countdown_label: Label = $CountdownLabel
@onready var time_label: Label = $ScorePanel/HBoxContainer/TimeLabel
@onready var score_label: Label = $ScorePanel/HBoxContainer/ScoreLabel
@onready var obstacle_label: Label = $ScorePanel/HBoxContainer/ObstacleLabel
@onready var faults_label: Label = $ScorePanel/HBoxContainer/FaultsLabel
@onready var gait_label: Label = $GaitPanel/GaitLabel

enum CountdownType
{
	None,
	Three,
	Two,
	One,
	Go
}


func _enter_tree() -> void:
	EventSystem.LEV_level_changed.connect(queue_free)
	EventSystem.HUD_set_countdown_text.connect(set_countdown_text)
	EventSystem.HUD_set_timer_text.connect(set_timer_text)
	EventSystem.HUD_set_score_text.connect(set_score_text)
	EventSystem.HUD_set_obstacle_text.connect(set_obstacle_text)
	EventSystem.HUD_set_faults_text.connect(set_faults_text)
	EventSystem.HUD_set_gait_text.connect(set_gait_text)


func set_countdown_text(countdown: CountdownType) -> void:
	var text: String
	
	match countdown:
		CountdownType.None:
			text = ""
		CountdownType.Three:
			text = "3"
		CountdownType.Two:
			text = "2"
		CountdownType.One:
			text = "1"
		CountdownType.Go:
			text = "Go!"
	
	countdown_label.text = text


func set_timer_text(text: String) -> void:
	time_label.text = text


func set_score_text(text: String) -> void:
	score_label.text = text


func set_obstacle_text(text: String) -> void:
	obstacle_label.text = text


func set_faults_text(text: String) -> void:
	faults_label.text = text


func set_gait_text(gait: Horse.Gaits):
	# Putting enum name to the label
	gait_label.text = Horse.Gaits.keys()[gait] 
