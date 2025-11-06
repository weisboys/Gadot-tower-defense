extends CharacterBody2D

@export var enemy_speed = 100

func _process(delta):
	var path_follow = get_parent()
	if path_follow is PathFollow2D:
		path_follow.progress += delta * enemy_speed
	if is_equal_approx(path_follow.progress_ratio, 1.0):
		print("enemy at end")
		path_follow.queue_free()
		
