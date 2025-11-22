extends Node2D

const TOWER_SPOT_OFFSET := Vector2(0,-20)

var is_placing: bool = false
var preview: Node2D = null
var placing_scene: PackedScene = null

@export var preview_alpha := 0.5

# start placing a new tower
func start_placement(packed_scene: PackedScene) -> void:
	if is_placing:
		return
	
	placing_scene = packed_scene
	preview = placing_scene.instantiate() as Node2D
	
	if preview != null and "preview_mode" in preview:
		preview.preview_mode = true
	
	if "modulate" in preview:
		preview.modulate = Color(1, 1, 1, preview_alpha)
	
	preview.z_as_relative = false
	preview.z_index = 100 #place in front
	
	add_child(preview)
	is_placing = true

# cancel placement
func cancel_placement() -> void:
	if preview:
		preview.queue_free()
	preview = null
	placing_scene = null
	is_placing = false

# attempt to place tower on a valid spot
func try_place() -> void:
	var gm = get_node("/root/Main/GameManager")
	
	if not is_placing or preview == null:
		return

	var mouse_pos: Vector2 = get_global_mouse_position()
	var space_state = get_world_2d().direct_space_state

	# create a query parameter object
	var query := PhysicsPointQueryParameters2D.new()
	query.position = mouse_pos
	query.collide_with_areas = true
	query.collide_with_bodies = false  #only need Area2D spots
	query.collision_mask = 0xFFFFFFFF  #all layers

	var result = space_state.intersect_point(query, 32) #32 = max results

	if result.size() == 0:
		print("nothing hit")
		return

	for hit in result:
		var collider = hit.collider
		if collider is TowerSpot:
			var spot: TowerSpot = collider #specify type explicitly

			if spot.occupied:
				print("spot already used")
				return
			
			if not gm.spend_coins(preview.cost):
				print("not enough coins")
				return
			
			#place tower
			spot.occupied = true
			preview.preview_mode = false
			preview.modulate = Color(1,1,1,1)
			preview.global_position = spot.global_position + TOWER_SPOT_OFFSET
			get_tree().get_current_scene().add_child(preview)
			preview.z_index = 100 #place in front

			#clear placement
			preview = null
			placing_scene = null
			is_placing = false
			return

	print("not a valid tower spot")

#update preview position
func _process(delta: float) -> void:
	if not is_placing or preview == null:
		return

	# Follow mouse
	preview.global_position = get_global_mouse_position()

#handle input
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:

		if is_placing:
			if event.button_index == MOUSE_BUTTON_LEFT:
				try_place()
				get_viewport().set_input_as_handled()
			elif event.button_index == MOUSE_BUTTON_RIGHT:
				cancel_placement()
				get_viewport().set_input_as_handled()
			return

		if event.button_index == MOUSE_BUTTON_RIGHT:
			try_delete_tower()
			get_viewport().set_input_as_handled()

func try_delete_tower() -> void:
	var mouse_pos = get_global_mouse_position()
	var space_state = get_world_2d().direct_space_state

	var query := PhysicsPointQueryParameters2D.new()
	query.position = mouse_pos
	query.collide_with_areas = true
	query.collide_with_bodies = false
	query.collision_mask = 2  # clicking tower areas

	var result = space_state.intersect_point(query, 8)

	if result.size() == 0:
		print("No tower clicked.")
		return

	# The result.collider is your Area2D, not the tower
	var area = result[0].collider
	var tower = area.get_parent()

	if tower == null:
		print("Error: click area has no tower parent")
		return

	print("Deleting tower:", tower)

	# Find the spot this tower is on
	var spot_pos = tower.global_position - TOWER_SPOT_OFFSET

	var query2 := PhysicsPointQueryParameters2D.new()
	query2.position = spot_pos
	query2.collide_with_areas = true
	query2.collide_with_bodies = false
	query2.collision_mask = 1  # TowerSpot layer

	var spot_hit = space_state.intersect_point(query2, 4)

	for s in spot_hit:
		if s.collider is TowerSpot:
			s.collider.occupied = false
			break

	tower.queue_free()
