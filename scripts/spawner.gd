extends Node2D

@export var enemy_scene: PackedScene
@export var spawn_interval := 0.2
@export var path_2d: Path2D

func _ready():
	print("Timer stopped? ", $Timer.is_stopped())
	$Timer.timeout.connect(_on_Timer_timeout)
	$Timer.wait_time = spawn_interval
	$Timer.start()

func _on_Timer_timeout():
	spawn_enemy()
	print("enemy spawned")

func spawn_enemy():
	# Instance the enemy scene
	var enemy = enemy_scene.instantiate() as Node2D

	# Create a PathFollow2D so each enemy moves independently
	var follower = PathFollow2D.new()
	follower.rotates = false  # Do not rotate the enemy along the path
	follower.loop = false     # Stop at the end
	follower.add_child(enemy)
	enemy.rotation = 0

	# Add the follower to the path
	path_2d.add_child(follower)
	follower.progress = 0.0
