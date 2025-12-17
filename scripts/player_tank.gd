extends CharacterBody2D

# 移动属性
@export var speed: float = 200.0
@export var rotation_speed: float = 3.0

# 战斗属性
@export var max_health: int = 3
@export var shoot_cooldown: float = 0.5

var current_health: int
var can_shoot: bool = true
var is_invulnerable: bool = false
var invulnerable_time: float = 2.0

# 节点引用
@onready var turret: Node2D = $Turret
@onready var shoot_point: Marker2D = $Turret/ShootPoint
@onready var shoot_timer: Timer = $ShootTimer
@onready var invulnerable_timer: Timer = $InvulnerableTimer
@onready var sprite: Sprite2D = $Sprite2D

# 子弹场景
var bullet_scene = preload("res://scenes/entities/bullet.tscn")

func _ready() -> void:
	current_health = max_health
	collision_layer = 1  # Player层
	collision_mask = 2 | 16 | 32  # Enemy | Wall | Destructible
	
	# 设置计时器
	shoot_timer.wait_time = shoot_cooldown
	shoot_timer.one_shot = true
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)
	
	invulnerable_timer.wait_time = invulnerable_time
	invulnerable_timer.one_shot = true
	invulnerable_timer.timeout.connect(_on_invulnerable_timer_timeout)

func _physics_process(delta: float) -> void:
	handle_movement(delta)
	handle_turret_rotation()
	handle_shooting()
	
	# 无敌时闪烁效果
	if is_invulnerable:
		sprite.modulate.a = 0.5 if int(Time.get_ticks_msec() / 100) % 2 == 0 else 1.0
	else:
		sprite.modulate.a = 1.0

func handle_movement(delta: float) -> void:
	# 获取输入方向
	var input_dir = Vector2.ZERO
	input_dir.x = Input.get_axis("move_left", "move_right")
	input_dir.y = Input.get_axis("move_up", "move_down")
	
	# 归一化并应用速度
	if input_dir.length() > 0:
		input_dir = input_dir.normalized()
		velocity = input_dir * speed
		
		# 旋转坦克体朝向移动方向
		var target_rotation = input_dir.angle()
		rotation = lerp_angle(rotation, target_rotation, rotation_speed * delta)
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()

func handle_turret_rotation() -> void:
	# 炮塔跟随鼠标
	var mouse_pos = get_global_mouse_position()
	turret.look_at(mouse_pos)

func handle_shooting() -> void:
	if Input.is_action_pressed("shoot") and can_shoot:
		shoot()

func shoot() -> void:
	can_shoot = false
	shoot_timer.start()
	
	# 生成子弹
	var bullet = bullet_scene.instantiate()
	bullet.global_position = shoot_point.global_position
	bullet.direction = Vector2.RIGHT.rotated(turret.global_rotation)
	bullet.rotation = turret.global_rotation
	bullet.is_player_bullet = true
	get_parent().add_child(bullet)

func take_damage(amount: int) -> void:
	if is_invulnerable:
		return
	
	current_health -= amount
	
	if current_health <= 0:
		die()
	else:
		# 受伤后无敌时间
		is_invulnerable = true
		invulnerable_timer.start()

func die() -> void:
	# 失去一条命
	Global.lose_life()
	# 创建爆炸效果（如果有）
	queue_free()

func _on_shoot_timer_timeout() -> void:
	can_shoot = true

func _on_invulnerable_timer_timeout() -> void:
	is_invulnerable = false
