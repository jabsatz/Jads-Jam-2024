extends Node2D

@export var resource : Vehicle

func _ready() -> void:
	$Sprite2D.texture = resource.icon

func look_to(direction: Vector2) -> void:
	$Sprite2D.flip_v = direction.x < 0
	$Label.position.y = -8 if direction.x < 0 else -24
	$Label.rotation = PI if direction.x < 0 else 0.0
	rotation = direction.angle()

func _process(delta):
	$Label.text = "%d" % resource.cargo_load
