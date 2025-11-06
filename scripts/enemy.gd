extends CharacterBody2D

@export var max_health := 3
@export var enemy_speed = 100
var current_health := max_health

func _process(delta):
	var path_follow = get_parent()
	if path_follow is PathFollow2D:
		path_follow.progress += delta * enemy_speed
	if is_equal_approx(path_follow.progress_ratio, 1.0):
		print("enemy at end")
		path_follow.queue_free()

func take_damage(amount: int) -> void:
	current_health -= amount
	if current_health <= 0:
		die()

func die() -> void:
	queue_free()
