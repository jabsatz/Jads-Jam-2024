extends Control

@onready var goldLabel: Label = %GoldLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	goldLabel.text = "%.2f" % GameManager.game_scene.gold


func _on_truck_button_pressed() -> void:
	pass  # Replace with function body.


func _on_worker_button_pressed() -> void:
	pass  # Replace with function body.


func _on_mine_button_pressed() -> void:
	pass  # Replace with function body.
