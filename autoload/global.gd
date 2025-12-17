extends Node

# 游戏状态枚举
enum GameState {
	MENU,
	PLAYING,
	PAUSED,
	GAME_OVER
}

# 全局游戏状态
var current_state: GameState = GameState.MENU

# 玩家统计
var player_score: int = 0
var player_lives: int = 3
var current_wave: int = 1
var enemies_killed: int = 0

# 游戏设置
var master_volume: float = 0.8
var sfx_volume: float = 0.8
var music_volume: float = 0.6
var difficulty: int = 1  # 1=简单, 2=中等, 3=困难

# 信号
signal score_changed(new_score)
signal lives_changed(new_lives)
signal wave_changed(new_wave)
signal game_state_changed(new_state)

func _ready() -> void:
	# 初始化游戏
	process_mode = Node.PROCESS_MODE_ALWAYS

func reset_game() -> void:
	"""重置游戏统计"""
	player_score = 0
	player_lives = 3
	current_wave = 1
	enemies_killed = 0
	emit_signal("score_changed", player_score)
	emit_signal("lives_changed", player_lives)
	emit_signal("wave_changed", current_wave)

func add_score(points: int) -> void:
	"""增加分数"""
	player_score += points
	emit_signal("score_changed", player_score)
	
	# 每10000分增加一条命
	if player_score % 10000 == 0 and player_score > 0:
		add_life()

func add_life() -> void:
	"""增加生命"""
	player_lives += 1
	emit_signal("lives_changed", player_lives)

func lose_life() -> void:
	"""失去生命"""
	player_lives -= 1
	emit_signal("lives_changed", player_lives)
	
	if player_lives <= 0:
		game_over()

func next_wave() -> void:
	"""进入下一波"""
	current_wave += 1
	emit_signal("wave_changed", current_wave)

func change_state(new_state: GameState) -> void:
	"""改变游戏状态"""
	current_state = new_state
	emit_signal("game_state_changed", new_state)
	
	# 根据状态设置暂停
	if new_state == GameState.PAUSED:
		get_tree().paused = true
	elif new_state == GameState.PLAYING:
		get_tree().paused = false

func game_over() -> void:
	"""游戏结束"""
	change_state(GameState.GAME_OVER)
	# 延迟加载游戏结束界面
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://scenes/menu/game_over.tscn")

func start_game() -> void:
	"""开始游戏"""
	reset_game()
	change_state(GameState.PLAYING)
	get_tree().change_scene_to_file("res://scenes/game/game_world.tscn")

func return_to_menu() -> void:
	"""返回主菜单"""
	change_state(GameState.MENU)
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")
