extends CharacterBody2D
@onready var collision: CollisionShape2D = $CollisionShape2D

@export var max_health := 3
@export var enemy_speed = 200
var current_health := max_health

func _ready() -> void:
	collision.disabled = false
	
func _process(delta):
	var path_follow = get_parent()
	if path_follow is PathFollow2D:
		path_follow.progress += delta * enemy_speed
	if is_equal_approx(path_follow.progress_ratio, 1.0):
		print("enemy at end")
		path_follow.queue_free()

func take_damage(amount: int) -> void:
	current_health -= amount
	flash_hit()
	if current_health <= 0:
		die()
		
func flash_hit():
	var sprite = $EnemyTemp
	sprite.modulate = Color(1,1,1,1) * 1.5
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color(1,1,1,1)
	
func die() -> void:
	collision.disabled = true
	var sprite = $EnemyTemp

	var tween = create_tween()
	tween.tween_property(sprite, "scale", Vector2(0, 0), 0.3)
	tween.tween_property(sprite, "modulate:a", 0, 0.3)

	await tween.finished
	queue_free()
