class_name Upgrade
extends Resource

var title := "Upgrade"
var description := "Upgrade description"
var cost := 2000.0
var effect := func(): return

func _init(_title: String, _description: String, _cost: float, _effect: Callable) -> void:
	title = _title
	description = _description
	cost = _cost
	effect = _effect