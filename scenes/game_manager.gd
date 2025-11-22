extends Node

var coins: int = 200

signal coins_changed(new_amount)

func add_coins(amount: int) -> void:
	coins += amount
	emit_signal("coins_changed", coins)

func spend_coins(amount: int) -> bool:
	if coins >= amount:
		coins -= amount
		emit_signal("coins_changed", coins)
		return true
	return false
