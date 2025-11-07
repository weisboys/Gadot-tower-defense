extends TextureButton

func _on_mouse_entered() -> void:
	self.modulate = Color(1, 1, 1, 0.8)

func _on_mouse_exited() -> void:
	self.modulate = Color(1, 1, 1, 1) 


func _on_pressed() -> void:
	pass # Replace with function body.
