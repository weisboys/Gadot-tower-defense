extends Area2D

@export var speed := 400
var target: Node = null
var direction = Vector2()
func _ready() -> void:
	print("target found, point towards enemy")
	direction = (target.global_position - global_position).normalized()

func _process(delta: float) -> void:	
	position += direction * speed * delta

func _on_visibility_screen_exited() -> void:
	queue_free()
	


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		body.take_damage(1)
		queue_free()
