class_name Mine
extends Resource

var mine_sprite: Texture2D = load('res://assets/mine_64.svg')
var inactive_mine_sprite: Texture2D = load('res://assets/mine_inactive_64.svg')
var active := false
var distance := 0.0
var gold_yield := randf_range(8.0, 18.0)
var vehicles : Array[Vehicle] = []
var max_vehicles := 3
var workers : Array[Worker] = []
var max_workers := 6
var storage := 0.0
var direction : Vector2 = Vector2(1,0).rotated(randf() * PI * 2.0)
var node = null
var road = null

func _init(_distance: float = randf_range(300, 1200), _active: bool = false) -> void:
	active = _active
	distance = _distance
	gold_yield = distance / 100.0 + 8.0
	max_vehicles = 2 + floor(distance / 450.0)

func get_road_cost():
	return int(distance) * 5 

func get_title():
	return "Mine" if active else "Mine (Inactive)"

func get_image():
	return mine_sprite if active else inactive_mine_sprite

func get_description():
	if active:
		var description = """Produces gold based on amount of workers. Transportation is required to carry the gold.

Yield: [b]{gold_yield}[/b] (producing [b]{production}[/b] per tick)
Distance to base: [b]{distance}km[/b]
Workers active: [b]{workers}/{max_workers}[/b]
Vehicles assigned: [b]{vehicles}/{max_vehicles}[/b]"""

		var production = workers.reduce(func(acc, w): return acc + w.speed, 0.0) * gold_yield

		return description.format({ "gold_yield": "%.2f" % gold_yield, "production": "%.2f" % production, "distance": "%d" % distance, "workers": workers.size(), "max_workers": max_workers, "vehicles": vehicles.size(), "max_vehicles": max_vehicles })

	else:
		var description = """Will produce gold once a road to it is built and workers are assigned.

Yield: [b]{gold_yield}[/b]
Distance to base: [b]{distance}km[/b]
Max workers: [b]{max_workers}[/b]
Max vehicles: [b]{max_vehicles}[/b]"""
		return description.format({ "gold_yield": "%.2f" % gold_yield, "distance": "%d" % distance, "max_workers": max_workers, "max_vehicles": max_vehicles })

func get_action_buttons():
	if not active:
		return [{
			"title": "Build road (%dG)" % get_road_cost(),
			"action": func(): node.build_road(),
			"disabled": GameManager.game_scene.gold < get_road_cost()
		}]
	if active:
		return [{
			"title": "Assign worker",
			"action": func(): node.assign_worker(),
			"disabled": GameManager.game_scene.workers.size() == 0 or workers.size() == max_workers
		},{
			"title": "Assign vehicle",
			"action": func(): node.assign_vehicle(),
			"disabled": GameManager.game_scene.vehicles.size() == 0 or vehicles.size() == max_vehicles
		},{
			"title": "Unassign worker",
			"action": func(): node.unassign_worker(),
			"disabled": workers.size() == 0
		},{
			"title": "Unassign vehicle",
			"action": func(): node.unassign_vehicle(),
			"disabled": vehicles.size() == 0,
			"tooltip": "WARNING: Any gold inside the vehicle WILL be lost"
		}]
