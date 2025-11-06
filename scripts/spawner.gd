extends Node2D

@export var enemy_scene: PackedScene
@export var spawn_interval := 0.2
@export var path_2d: Path2D
@export var wave_pause := 2.0
var waves := [3, 6, 15, 8, 12, 15, 20, 15, 25, 20, 30]
var current_wave := 0
var enemies_left := 0

func _ready():
	print("Timer stopped? ", $Timer.is_stopped())
	$Timer.timeout.connect(_on_Timer_timeout)
	$Timer.wait_time = spawn_interval
	start_wave()

func start_wave():
	if current_wave >= waves.size():
		print("all waves complete")
		return
	
	enemies_left = waves[current_wave]
	current_wave += 1
	$Timer.start()
	print("starting wave %d with %d enemies" % [current_wave,enemies_left])

func _on_Timer_timeout():
	if enemies_left > 0:
		spawn_enemy()
		enemies_left -= 1
	else:
		$Timer.stop()
		print("wave complete")	
		await get_tree().create_timer(wave_pause).timeout
		start_wave()

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
	print("enemy spawned")
