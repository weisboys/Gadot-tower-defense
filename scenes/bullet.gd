extends Area2D

@export var speed := 400
var target: Node = null

func _process(delta: float) -> void:
	if target == null:
		return
	
	var direction = (target.global_position - global_position).normalized()
	
	position += direction * speed * delta

func _on_visibility_screen_exited() -> void:
	queue_free()
	


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		queue_free()
