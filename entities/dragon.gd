extends Area2D

var values = [
	{
		"title": "Dragon Lord",
		"icon": load("res://assets/dragon.svg"),
		"description": "Dragons love hoarding gold and treasure. Keep a steady flow to stay happy!"
	},
	{
		"title": "Cool Dragon Lord",
		"icon": load("res://assets/dragon_sunglasses.svg"),
		"description": "You never looked cooler, imagine all the cool stuff you'll get next!"
	},
	{
		"title": "Wealthy Dragon Lord",
		"icon": load("res://assets/dragon_cigar.svg"),
		"description": "Now that you've had a taste for riches, this door cannot be closed..."
	},
	{
		"title": "The Dragon Magnate",
		"icon": load("res://assets/dragon_tophat.svg"),
		"description": "Space is the final frontier. Your empire must continue it's growth."
	},
]


func _ready():
	$Sprite2D.texture = values[GameManager.level]["icon"]


func _mouse_enter() -> void:
	if not GameManager.ui.info_is_pinned:
		GameManager.ui.show_info(
			"%s (You)" % values[GameManager.level]["title"],
			values[GameManager.level]["icon"],
			values[GameManager.level]["description"]
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
	$Sprite2D.texture = values[GameManager.level + 1]["icon"]
