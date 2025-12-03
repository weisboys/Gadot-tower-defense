extends CanvasLayer

@onready var coin_label: Label = $CoinLabel
@onready var tower_button = $BuyTowerButton
@onready var lives_label = $LivesLabel

@export var tower_scene: PackedScene
@export var placement_controller_path: NodePath = NodePath("../PlacementController")

func _ready() -> void:
	tower_button.pressed.connect(_on_buy_pressed)

	var gm = get_node("/root/Main/GameManager")
	
	coin_label.text = str(gm.coins)
	gm.coins_changed.connect(_on_coins_changed)
	
	lives_label.text = str(gm.lives)
	gm.lives_changed.connect(_on_lives_changed)
	
func _on_buy_pressed() -> void:
	var controller = get_node_or_null(placement_controller_path)
	if controller:
		controller.start_placement(tower_scene)

func _on_coins_changed(value: int):
	coin_label.text = str(value)

func _on_lives_changed(value: int):
	lives_label.text = str(value)
