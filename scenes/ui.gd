extends CanvasLayer

@export var tower_scene: PackedScene
@export var placement_controller_path: NodePath = NodePath("../PlacementController")

func _ready() -> void:
	$BuyTowerButton.pressed.connect(_on_buy_pressed)

func _on_buy_pressed() -> void:
	var controller = get_node_or_null(placement_controller_path)
	if controller:
		controller.start_placement(tower_scene)
