extends CharacterBody2D

# AI状态枚举
enum State {
	PATROL,
	CHASE,
	ATTACK,
	RETREAT
}

# 移动属性
@export var speed: float = 100.0
@export var rotation_speed: float = 2.0

# 战斗属性
@export var max_health: int = 2
@export var shoot_cooldown: float = 1.5
@export var detection_range: float = 400.0
@export var attack_range: float = 300.0
@export var min_attack_distance: float = 150.0
@export var score_value: int = 100

var current_health: int
var current_state: State = State.PATROL
var can_shoot: bool = true
var player: Node2D = null
var patrol_target: Vector2
var patrol_timer: float = 0.0

# 节点引用
@onready var turret: Node2D = $Turret
@onready var shoot_point: Marker2D = $Turret/ShootPoint
@onready var shoot_timer: Timer = $ShootTimer
@onready var detection_area: Area2D = $DetectionArea
@onready var sprite: Sprite2D = $Sprite2D

# 子弹场景
var bullet_scene = preload("res://scenes/entities/bullet.tscn")

func _ready() -> void:
	current_health = max_health
	collision_layer = 2  # Enemy层
	collision_mask = 1 | 16 | 32  # Player | Wall | Destructible
	
	# 设置计时器
	shoot_timer.wait_time = shoot_cooldown
	shoot_timer.one_shot = true
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)
	
	# 设置检测区域
	var circle = CircleShape2D.new()
	circle.radius = detection_range
	detection_area.get_child(0).shape = circle
	detection_area.body_entered.connect(_on_detection_area_body_entered)
	detection_area.body_exited.connect(_on_detection_area_body_exited)
	
	# 初始巡逻目标
	choose_patrol_target()
	
	add_to_group("enemies")

func _physics_process(delta: float) -> void:
	match current_state:
		State.PATROL:
			patrol_behavior(delta)
		State.CHASE:
			chase_behavior(delta)
		State.ATTACK:
			attack_behavior(delta)
		State.RETREAT:
			retreat_behavior(delta)
	
	move_and_slide()

func patrol_behavior(delta: float) -> void:
	# 向巡逻目标移动
	var direction = (patrol_target - global_position).normalized()
	velocity = direction * speed * 0.5
	
	# 旋转朝向移动方向
	if direction.length() > 0:
		var target_rotation = direction.angle()
		rotation = lerp_angle(rotation, target_rotation, rotation_speed * delta)
	
	# 到达目标或超时则选择新目标
	if global_position.distance_to(patrol_target) < 20 or patrol_timer <= 0:
		choose_patrol_target()
	
	patrol_timer -= delta

func chase_behavior(delta: float) -> void:
	if not player:
		current_state = State.PATROL
		return
	
	var distance_to_player = global_position.distance_to(player.global_position)
	
	# 进入攻击范围
	if distance_to_player < attack_range:
		current_state = State.ATTACK
		return
	
	# 追击玩家
	var direction = (player.global_position - global_position).normalized()
	velocity = direction * speed
	
	# 旋转朝向玩家
	var target_rotation = direction.angle()
	rotation = lerp_angle(rotation, target_rotation, rotation_speed * delta)
	
	# 炮塔瞄准玩家
	turret.look_at(player.global_position)

func attack_behavior(delta: float) -> void:
	if not player:
		current_state = State.PATROL
		return
	
	var distance_to_player = global_position.distance_to(player.global_position)
	
	# 太近则后退
	if distance_to_player < min_attack_distance:
		current_state = State.RETREAT
		return
	
	# 太远则追击
	if distance_to_player > attack_range:
		current_state = State.CHASE
		return
	
	# 保持距离并瞄准射击
	var direction = (player.global_position - global_position).normalized()
	
	# 轻微移动保持距离
	var perpendicular = Vector2(-direction.y, direction.x)
	if randf() > 0.5:
		perpendicular = -perpendicular
	velocity = perpendicular * speed * 0.3
	
	# 炮塔瞄准玩家
	turret.look_at(player.global_position)
	
	# 旋转坦克体
	var target_rotation = direction.angle()
	rotation = lerp_angle(rotation, target_rotation, rotation_speed * delta * 0.5)
	
	# 射击
	if can_shoot:
		shoot()

func retreat_behavior(delta: float) -> void:
	if not player:
		current_state = State.PATROL
		return
	
	var distance_to_player = global_position.distance_to(player.global_position)
	
	# 距离足够则转为攻击
	if distance_to_player > min_attack_distance * 1.2:
		current_state = State.ATTACK
		return
	
	# 远离玩家
	var direction = (global_position - player.global_position).normalized()
	velocity = direction * speed
	
	# 旋转朝向移动方向
	var target_rotation = direction.angle()
	rotation = lerp_angle(rotation, target_rotation, rotation_speed * delta)
	
	# 炮塔仍然瞄准玩家
	turret.look_at(player.global_position)

func choose_patrol_target() -> void:
	# 在附近随机选择巡逻点
	var random_offset = Vector2(randf_range(-200, 200), randf_range(-200, 200))
	patrol_target = global_position + random_offset
	patrol_timer = randf_range(3.0, 6.0)

func shoot() -> void:
	can_shoot = false
	shoot_timer.start()
	
	# 生成子弹
	var bullet = bullet_scene.instantiate()
	bullet.global_position = shoot_point.global_position
	bullet.direction = Vector2.RIGHT.rotated(turret.global_rotation)
	bullet.rotation = turret.global_rotation
	bullet.is_player_bullet = false
	get_parent().add_child(bullet)

func take_damage(amount: int) -> void:
	current_health -= amount
	
	# 受伤闪烁效果
	sprite.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color.WHITE
	
	if current_health <= 0:
		die()

func die() -> void:
	# 增加分数
	Global.add_score(score_value)
	Global.enemies_killed += 1
	
	# 创建爆炸效果（如果有）
	queue_free()

func _on_shoot_timer_timeout() -> void:
	can_shoot = true

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		if current_state == State.PATROL:
			current_state = State.CHASE

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body == player:
		player = null
		current_state = State.PATROL
