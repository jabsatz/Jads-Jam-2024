extends Area2D

var dragon_textures = [
	load("res://assets/dragon.svg"),
	load("res://assets/dragon_sunglasses.svg"),
	load("res://assets/dragon_cigar.svg"),
	load("res://assets/dragon_tophat.svg")
]

@export_range(0, 3, 1) var level := 0

func _ready():
	$Sprite2D.texture = dragon_textures[level]

func _mouse_enter() -> void:
	if not GameManager.ui.info_is_pinned:
		GameManager.ui.show_info(
			"Dragon Lord (You)",
			dragon_textures[level],
			"Dragons love hoarding gold and treasure. Keep a steady flow to stay happy!"
		)


func _mouse_exit() -> void:
	if not GameManager.ui.info_is_pinned:
		GameManager.ui.hide_info()


func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if (
		event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
		and event.is_pressed()
	):
		viewport.set_input_as_handled()


func upgrade():
	level += 1
	$Sprite2D.texture = dragon_textures[level]
