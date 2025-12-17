extends Control

@onready var resume_button: Button = $PanelContainer/MarginContainer/VBoxContainer/ResumeButton
@onready var restart_button: Button = $PanelContainer/MarginContainer/VBoxContainer/RestartButton
@onready var menu_button: Button = $PanelContainer/MarginContainer/VBoxContainer/MenuButton

func _ready() -> void:
	resume_button.pressed.connect(_on_resume_button_pressed)
	restart_button.pressed.connect(_on_restart_button_pressed)
	menu_button.pressed.connect(_on_menu_button_pressed)
	
	# 初始隐藏
	hide()

func _on_resume_button_pressed() -> void:
	hide()
	Global.change_state(Global.GameState.PLAYING)

func _on_restart_button_pressed() -> void:
	hide()
	Global.start_game()

func _on_menu_button_pressed() -> void:
	hide()
	Global.return_to_menu()

func show_pause() -> void:
	show()

func hide_pause() -> void:
	hide()
