extends Camera2D

signal animation_complete

@export var SPEED := 20.0
@export var ZOOM_SPEED := 30.0
@export var ZOOM_MARGIN := 0.1
@export var ZOOM_MIN := 0.25
@export var ZOOM_MAX := 4.0

var zoom_factor := 1.0
var zoom_pos := Vector2()
var zooming := false
var mouse_start_pos : Vector2
var screen_start_pos : Vector2
var dragging := false
var centering := false
var move_enabled := true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.camera = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if centering or not move_enabled:
		return

	var input := Vector2(Input.get_axis("CameraLeft", "CameraRight"), Input.get_axis("CameraUp", "CameraDown"))

	position = lerp(position, position + input * SPEED, SPEED * delta)

	zoom = lerp(zoom, zoom * zoom_factor, ZOOM_SPEED*delta)
	zoom = clamp(zoom, Vector2(ZOOM_MIN, ZOOM_MIN), Vector2(ZOOM_MAX, ZOOM_MAX))

	if not zooming:
		zoom_factor = 1.0

func _input(event: InputEvent) -> void:
	if centering or not move_enabled:
		return

	if abs(zoom_pos - get_global_mouse_position()).x > ZOOM_MARGIN or abs(zoom_pos - get_global_mouse_position()).y > ZOOM_MARGIN:
		zoom_factor = 1.0
	
	if event.is_action("Drag"):
		if event.is_pressed():
			mouse_start_pos = event.position
			screen_start_pos = position
			dragging = true
		else:
			dragging = false
	elif event is InputEventMouseMotion and dragging:
		position = (mouse_start_pos - event.position) / zoom + screen_start_pos

	if event is InputEventMouseButton:
		if event.is_pressed() and (event.is_action("WheelDown") or event.is_action("WheelUp")):
			zooming = true
			if event.is_action("WheelDown"):
				zoom_factor -= 0.01 * ZOOM_SPEED
				zoom_pos = get_global_mouse_position()
			if event.is_action("WheelUp"):
				zoom_factor += 0.01 * ZOOM_SPEED
				zoom_pos = get_global_mouse_position()
		else:
			zooming = false

func center_on_position(pos: Vector2, time: float = 1.0):
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	centering = true
	tween.tween_property(self, "position", pos, time)
	tween.parallel().tween_property(self, "zoom", Vector2.ONE, time)
	tween.chain().tween_property(self, "zoom", Vector2.ONE * 2.0, time/2)
	await tween.finished
	centering = false
	animation_complete.emit()
