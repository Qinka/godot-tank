extends Area2D

# 子弹属性
@export var speed: float = 500.0
@export var damage: int = 1
@export var max_distance: float = 1000.0
@export var is_player_bullet: bool = true

var direction: Vector2 = Vector2.RIGHT
var traveled_distance: float = 0.0

func _ready() -> void:
	# 设置碰撞层和遮罩
	if is_player_bullet:
		collision_layer = 4  # PlayerBullet层
		collision_mask = 2 | 16 | 32  # Enemy | Wall | Destructible
	else:
		collision_layer = 8  # EnemyBullet层
		collision_mask = 1 | 16 | 32  # Player | Wall | Destructible
	
	# 连接碰撞信号
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)

func _physics_process(delta: float) -> void:
	# 移动子弹
	var movement = direction * speed * delta
	position += movement
	traveled_distance += movement.length()
	
	# 超过最大距离则销毁
	if traveled_distance >= max_distance:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	# 击中物体
	if body.has_method("take_damage"):
		body.take_damage(damage)
	
	# 如果击中可破坏物体
	if body.is_in_group("destructible"):
		body.take_damage(damage)
	
	# 销毁子弹
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	# 击中区域
	if area.has_method("take_damage"):
		area.take_damage(damage)
	
	queue_free()
