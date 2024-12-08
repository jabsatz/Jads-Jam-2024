extends Area2D

@export var resource : Vehicle

func _ready() -> void:
	$Sprite2D.texture = resource.icon
	$ProgressBar.max_value = resource.capacity

func look_to(direction: Vector2) -> void:
	$Sprite2D.flip_v = direction.x < 0
	$ProgressBar.position.y = 8 if direction.x < 0 else -20
	$ProgressBar.rotation = PI if direction.x < 0 else 0.0
	rotation = direction.angle()

func _process(delta):
	$ProgressBar.value = resource.cargo_load

func _mouse_enter() -> void:
	if not GameManager.ui.info_is_pinned:
		GameManager.ui.show_resource(resource)


func _mouse_exit() -> void:
	if not GameManager.ui.info_is_pinned:
		GameManager.ui.hide_info()

