extends Node2D

var inactive_mine_sprite: Texture2D = load('res://assets/mine_inactive_64.svg')

var mine: Mine


func setup(_mine):
	mine = _mine


func _process(delta):
	if mine.active:
		$Label.text = "%d" % mine.storage
	if not mine.active:
		$Sprite2D.texture = inactive_mine_sprite
		$Label.text = ""


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.mouse_index == MOUSE_BUTTON_LEFT:
		print('clicked mine at %d' % mine.distance)
