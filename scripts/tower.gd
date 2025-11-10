extends Node2D

@export var bullet_scene: PackedScene
@export var fire_rate := 0.4
@export var range := 150.0

var enemies_in_range: Array = []
var preview_mode: bool = false

func _ready() -> void:
	$RangeArea/CollisionShape2D.shape.radius = range
	
	$RangeArea.body_entered.connect(_on_body_entered)
	$RangeArea.body_exited.connect(_on_body_exited)

	$ShootTimer.wait_time = fire_rate
	$ShootTimer.timeout.connect(shoot)
	$ShootTimer.start()
	
	if has_node("ClickArea"):
		var click_area: Area2D = $ClickArea
		click_area.collision_layer = 2 #layer for tower click
		click_area.collision_mask = 0 #doesn't detect anything

func _on_body_entered(body):
	enemies_in_range.append(body)

func _on_body_exited(body):
	enemies_in_range.erase(body)

#func _on_ShootTimer_timeout(): <----basic shooting method 
	#shoot()

func shoot():
	if preview_mode:
		return
	
	enemies_in_range = enemies_in_range.filter(func(e): #adjust array to remove dead enemies
		return e.current_health > 0 and is_instance_valid(e)
	)
	
	if enemies_in_range.size() == 0:
		return
	
	var target = enemies_in_range[0]
	
	var bullet = bullet_scene.instantiate()
	bullet.position = global_position
	bullet.target = target
	get_parent().add_child(bullet)
