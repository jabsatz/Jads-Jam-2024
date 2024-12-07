extends Camera2D

#Camera Control

@export var SPEED := 20.0
@export var ZOOM_SPEED := 30.0
@export var ZOOM_MARGIN := 0.1
@export var ZOOM_MIN := 0.5
@export var ZOOM_MAX := 3.0

var zoomFactor := 1.0
var zoomPos := Vector2()
var zooming := false
var mousePos := Vector2()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.camera = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var input := Vector2(Input.get_axis("CameraLeft", "CameraRight"), Input.get_axis("CameraUp", "CameraDown"))

	position = lerp(position, position + input * SPEED, SPEED * delta)

	zoom = lerp(zoom, zoom * zoomFactor, ZOOM_SPEED*delta)
	zoom = clamp(zoom, Vector2(ZOOM_MIN, ZOOM_MIN), Vector2(ZOOM_MAX, ZOOM_MAX))

	if not zooming:
		zoomFactor = 1.0

func _input(event: InputEvent) -> void:
	if abs(zoomPos - get_global_mouse_position()).x > ZOOM_MARGIN or abs(zoomPos - get_global_mouse_position()).y > ZOOM_MARGIN:
		zoomFactor = 1.0
	
	if event is InputEventMouseButton:
		if event.is_pressed():
			zooming = true
			if event.is_action("WheelDown"):
				zoomFactor -= 0.01 * ZOOM_SPEED
				zoomPos = get_global_mouse_position()
			if event.is_action("WheelUp"):
				zoomFactor += 0.01 * ZOOM_SPEED
				zoomPos = get_global_mouse_position()
		else:
			zooming = false