extends TextureButton

@export var tower_scene: PackedScene
@onready var cost_label: Label = $CostLabel

func _ready() -> void:
	print("tower_scene is:", tower_scene)
	if tower_scene:
		print("yes")
		var temp_tower = tower_scene.instantiate()
		cost_label.text = str(temp_tower.cost)
		temp_tower.queue_free()

func _on_mouse_entered() -> void:
	self.modulate = Color(1, 1, 1, 0.8)

func _on_mouse_exited() -> void:
	self.modulate = Color(1, 1, 1, 1) 

func _on_pressed() -> void:
	pass # Replace with function body.
