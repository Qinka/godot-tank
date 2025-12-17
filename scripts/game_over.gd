extends Control

@onready var final_score_label: Label = $MarginContainer/VBoxContainer/FinalScoreLabel
@onready var stats_label: Label = $MarginContainer/VBoxContainer/StatsLabel
@onready var restart_button: Button = $MarginContainer/VBoxContainer/RestartButton
@onready var menu_button: Button = $MarginContainer/VBoxContainer/MenuButton

func _ready() -> void:
	restart_button.pressed.connect(_on_restart_button_pressed)
	menu_button.pressed.connect(_on_menu_button_pressed)
	
	# 显示统计信息
	final_score_label.text = "最终分数: " + str(Global.player_score)
	stats_label.text = "击杀敌人: " + str(Global.enemies_killed) + "\n" + \
					   "存活波次: " + str(Global.current_wave)

func _on_restart_button_pressed() -> void:
	Global.start_game()

func _on_menu_button_pressed() -> void:
	Global.return_to_menu()
