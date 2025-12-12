extends CanvasLayer

@onready var coin_label: Label = $CoinLabel
@onready var tower_button = $BuyTowerButton
@onready var lives_label = $LivesLabel
@onready var gameover_label = $GameOverLabel
@onready var screen_flash = $ScreenFlash

@export var tower_scene: PackedScene
@export var placement_controller_path: NodePath = NodePath("../PlacementController")

func _ready() -> void:
	tower_button.pressed.connect(_on_buy_pressed)

	var gm = get_node("/root/Main/GameManager")
	
	coin_label.text = str(gm.coins)
	gm.coins_changed.connect(_on_coins_changed)
	
	lives_label.text = str(gm.lives)
	gm.lives_changed.connect(_on_lives_changed)
	gm.enemy_leaked.connect(_on_enemy_leaked)
	gm.game_over.connect(_on_game_over)
	
func _on_buy_pressed() -> void:
	var controller = get_node_or_null(placement_controller_path)
	if controller:
		controller.start_placement(tower_scene)

func _on_coins_changed(value: int):
	coin_label.text = str(value)

func _on_lives_changed(value: int):
	lives_label.text = str(value)

func _on_enemy_leaked() -> void:
	var c: Color = screen_flash.modulate
	c.a = 0.6
	screen_flash.modulate = c
	
	var t = create_tween()
	t.tween_property(screen_flash, "modulate:a", 0, 0.6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _on_game_over() -> void:
	gameover_label.visible = true
	get_tree().paused = true
