extends Control

# HUD元素引用
@onready var score_label: Label = $MarginContainer/VBoxContainer/TopBar/ScoreLabel
@onready var lives_label: Label = $MarginContainer/VBoxContainer/TopBar/LivesLabel
@onready var wave_label: Label = $MarginContainer/VBoxContainer/TopBar/WaveLabel

func _ready() -> void:
	# 连接全局信号
	Global.score_changed.connect(_on_score_changed)
	Global.lives_changed.connect(_on_lives_changed)
	Global.wave_changed.connect(_on_wave_changed)
	
	# 初始化显示
	update_display()

func update_display() -> void:
	_on_score_changed(Global.player_score)
	_on_lives_changed(Global.player_lives)
	_on_wave_changed(Global.current_wave)

func _on_score_changed(new_score: int) -> void:
	score_label.text = "分数: " + str(new_score)

func _on_lives_changed(new_lives: int) -> void:
	lives_label.text = "生命: " + str(new_lives)

func _on_wave_changed(new_wave: int) -> void:
	wave_label.text = "波次: " + str(new_wave)
