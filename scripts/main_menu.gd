extends Control

@onready var start_button: Button = $MarginContainer/VBoxContainer/StartButton
@onready var quit_button: Button = $MarginContainer/VBoxContainer/QuitButton
@onready var title_label: Label = $MarginContainer/VBoxContainer/TitleLabel

func _ready() -> void:
	start_button.pressed.connect(_on_start_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	
	# 确保游戏不处于暂停状态
	get_tree().paused = false

func _on_start_button_pressed() -> void:
	Global.start_game()

func _on_quit_button_pressed() -> void:
	get_tree().quit()
