extends CanvasLayer

@onready var coin_label: Label = $CoinLabel

@export var tower_scene: PackedScene
@export var placement_controller_path: NodePath = NodePath("../PlacementController")

func _ready() -> void:
	$BuyTowerButton.pressed.connect(_on_buy_pressed)

	var gm = get_node("/root/Main/GameManager")
	coin_label.text = str(gm.coins)
	gm.coins_changed.connect(_on_coins_changed)

func _on_buy_pressed() -> void:
	var controller = get_node_or_null(placement_controller_path)
	if controller:
		controller.start_placement(tower_scene)

func _on_coins_changed(value: int):
	coin_label.text = str(value)
