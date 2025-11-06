extends Node2D

var is_placing: bool = false
var preview: Node2D = null
var placing_scene: PackedScene = null

@export var preview_alpha := 0.5

func start_placement(packed_scene: PackedScene) -> void:
	if is_placing:
		return
	placing_scene = packed_scene
	preview = placing_scene.instantiate() as Node2D
	if preview != null and "preview_mode" in preview:
		preview.preview_mode = true
	
	if "modulate" in preview:
		preview.modulate = Color(1,1,1, preview_alpha)
	add_child(preview)
	is_placing = true

func cancel_placement() -> void:
	if preview:
		preview.queue_free()
	preview = null
	placing_scene = null
	is_placing = false

func place_here() -> void:
	preview.preview_mode = false
	if not is_placing or preview == null:
		return
		
	if "modulate" in preview:
		preview.modulate = Color(1,1,1,1)
	preview = null
	placing_scene = null
	is_placing = false
	
	if preview != null and "preview_mode" in preview:
		preview.preview_mode = false
	#preview node remains in scene as the placed tower

func _process(delta: float) -> void:
	if not is_placing or preview == null:
		return
	preview.global_position = get_global_mouse_position()

func _unhandled_input(event: InputEvent) -> void:
	if not is_placing:
		return
	
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			place_here()
			get_viewport().set_input_as_handled()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			cancel_placement()
			get_viewport().set_input_as_handled()
