extends Node

# 节点引用
@onready var player: CharacterBody2D = null
@onready var enemy_spawner: Node2D = null
@onready var hud: Control = null
@onready var pause_menu: Control = null

func _ready() -> void:
	# 查找场景中的节点
	await get_tree().process_frame
	
	player = get_tree().get_first_node_in_group("player")
	enemy_spawner = get_tree().get_first_node_in_group("enemy_spawner")
	hud = get_tree().get_first_node_in_group("hud")
	pause_menu = get_tree().get_first_node_in_group("pause_menu")
	
	# 设置游戏状态
	Global.change_state(Global.GameState.PLAYING)
	
	# 连接信号
	if enemy_spawner:
		enemy_spawner.wave_started.connect(_on_wave_started)
		enemy_spawner.all_enemies_defeated.connect(_on_all_enemies_defeated)

func _process(_delta: float) -> void:
	# 检查暂停输入
	if Input.is_action_just_pressed("pause"):
		toggle_pause()

func toggle_pause() -> void:
	if Global.current_state == Global.GameState.PLAYING:
		Global.change_state(Global.GameState.PAUSED)
		show_pause_menu()
	elif Global.current_state == Global.GameState.PAUSED:
		Global.change_state(Global.GameState.PLAYING)
		hide_pause_menu()

func show_pause_menu() -> void:
	if pause_menu:
		pause_menu.show_pause()

func hide_pause_menu() -> void:
	if pause_menu:
		pause_menu.hide_pause()

func _on_wave_started(wave_number: int) -> void:
	print("Wave ", wave_number, " started!")

func _on_all_enemies_defeated() -> void:
	print("All enemies defeated! Next wave incoming...")
