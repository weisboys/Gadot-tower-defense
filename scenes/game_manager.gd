extends Node

var coins: int = 200
@export var starting_lives := 10
var lives := 0

signal coins_changed(new_amount)
signal lives_changed(new_lives_amount)
signal enemy_leaked()
signal game_over

var is_game_over: bool = false

func _ready():
	lives = starting_lives
	emit_signal("lives_changed",lives)
	
func add_coins(amount: int) -> void:
	coins += amount
	emit_signal("coins_changed", coins)

func spend_coins(amount: int) -> bool:
	if coins >= amount:
		coins -= amount
		emit_signal("coins_changed", coins)
		return true
	return false

func lose_life():
	if is_game_over:
		return
	
	lives -= 1
	emit_signal("lives_changed", lives)
	emit_signal("enemy_leaked")
	if lives <= 0:
		is_game_over = true
		emit_signal("game_over")
