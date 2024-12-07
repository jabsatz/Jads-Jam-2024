@tool
extends Button

@export var building: Building:
	set(b):
		$TextureRect.texture = b.icon
		building = b

@onready var textureRect : TextureRect = $TextureRect

func _on_pressed() -> void:
	GameManager.game_scene.enter_building_mode(building)