extends StaticBody2D

@export var max_health: int = 2
var current_health: int

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	current_health = max_health

func take_damage(amount: int) -> void:
	current_health -= amount
	
	# 受伤变暗
	sprite.modulate = sprite.modulate.darkened(0.2)
	
	if current_health <= 0:
		destroy()

func destroy() -> void:
	# 创建爆炸效果（如果有）
	queue_free()
