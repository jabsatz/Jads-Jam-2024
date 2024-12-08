extends Area2D

var dragon_texture = load("res://assets/dragon.svg")


func _mouse_enter() -> void:
	if not GameManager.ui.info_is_pinned:
		GameManager.ui.show_info(
			"Dragon Lord (You)",
			dragon_texture,
			"Dragons love hoarding gold and treasure. Keep a steady flow to stay happy!"
		)


func _mouse_exit() -> void:
	if not GameManager.ui.info_is_pinned:
		GameManager.ui.hide_info()
