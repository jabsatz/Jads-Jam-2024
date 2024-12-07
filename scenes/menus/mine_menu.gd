extends Control

@onready var window = %Window

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	window.position.x = clamp(window.position.x, 10, get_viewport().size.x - window.size.x - 10)
	window.position.y = clamp(window.position.y, 50, get_viewport().size.y - window.size.y - 10)
	
