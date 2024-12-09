extends Control

@onready var scroll_container : ScrollContainer = %ScrollContainer

var progress := 0.0
var speed := 30

func _process(delta: float) -> void:
	progress += delta * speed
	scroll_container.scroll_vertical = floor(progress)
	if scroll_container.scroll_vertical + 2 < progress:
		GameManager.level = 0
		SceneManager.change_scene("res://scenes/game.tscn")

func _input(event: InputEvent) -> void:
	if (
		event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
	):
		if event.is_pressed():
			speed += 300
		else:
			speed -= 300
