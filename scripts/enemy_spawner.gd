extends Node2D

# 生成属性
@export var spawn_points: Array[Marker2D] = []
@export var enemies_per_wave: int = 3
@export var spawn_interval: float = 2.0
@export var wave_clear_delay: float = 3.0

var enemy_scene = preload("res://scenes/entities/enemy_tank.tscn")
var enemies_to_spawn: int = 0
var current_enemies: int = 0
var is_spawning: bool = false

@onready var spawn_timer: Timer = $SpawnTimer
@onready var wave_timer: Timer = $WaveTimer

signal wave_started(wave_number: int)
signal wave_completed(wave_number: int)
signal all_enemies_defeated()

func _ready() -> void:
	spawn_timer.wait_time = spawn_interval
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	
	wave_timer.wait_time = wave_clear_delay
	wave_timer.one_shot = true
	wave_timer.timeout.connect(_on_wave_timer_timeout)
	
	# 自动查找生成点
	if spawn_points.is_empty():
		for child in get_children():
			if child is Marker2D:
				spawn_points.append(child)
	
	# 开始第一波
	start_wave()

func start_wave() -> void:
	var wave = Global.current_wave
	enemies_to_spawn = enemies_per_wave + (wave - 1) * 2  # 每波增加2个敌人
	current_enemies = 0
	is_spawning = true
	emit_signal("wave_started", wave)
	spawn_timer.start()

func _on_spawn_timer_timeout() -> void:
	if enemies_to_spawn > 0 and spawn_points.size() > 0:
		spawn_enemy()
		enemies_to_spawn -= 1
		current_enemies += 1
	else:
		spawn_timer.stop()
		is_spawning = false

func spawn_enemy() -> void:
	# 随机选择生成点
	var spawn_point = spawn_points[randi() % spawn_points.size()]
	
	# 生成敌人
	var enemy = enemy_scene.instantiate()
	enemy.global_position = spawn_point.global_position
	get_parent().add_child(enemy)
	
	# 连接敌人死亡信号
	enemy.tree_exited.connect(_on_enemy_defeated)

func _on_enemy_defeated() -> void:
	current_enemies -= 1
	
	# 检查是否清空所有敌人
	if current_enemies <= 0 and not is_spawning:
		emit_signal("all_enemies_defeated")
		wave_timer.start()

func _on_wave_timer_timeout() -> void:
	# 进入下一波
	Global.next_wave()
	emit_signal("wave_completed", Global.current_wave - 1)
	start_wave()

func get_remaining_enemies() -> int:
	return current_enemies + enemies_to_spawn
