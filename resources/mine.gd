class_name Mine
extends Resource

const SPRITES : Array[Texture2D] = [
	preload('res://assets/mine.svg'),
	preload('res://assets/mine_island.svg'),
	preload('res://assets/mega_mine.svg'),
	preload('res://assets/gold_asteroid.svg')
]
const INACTIVE_SPRITES : Array[Texture2D] = [
	preload('res://assets/mine_inactive.svg'),
	preload('res://assets/mine_island_inactive.svg'),
	preload('res://assets/mega_mine_inactive.svg'),
	preload('res://assets/gold_asteroid_inactive.svg')
]
const TITLES : Array[String] = ["Mine", "Mine island", "Mega Mine", "Gold Asteroid"]
const LEVEL_MULTIPLIERS : Array[float] = [1.0, 5.0, 15.0, 50.0]

var sprite: Texture2D
var inactive_sprite: Texture2D
var level : int
var active : bool
var distance : float
var gold_yield : float
var max_vehicles : int
var max_workers : int
var cost : int

var vehicles : Array[Vehicle] = []
var workers : Array[Worker] = []
var storage := 0.0
var direction : Vector2 = Vector2(1,0).rotated(randf() * PI * 2.0)
var node = null
var road = null

func _init(_distance: float = randf_range(300, 1200), _level : int = 0, _active: bool = false) -> void:
	active = _active
	level = _level
	distance = _distance
	gold_yield = (distance / 100.0 + 8.0) * LEVEL_MULTIPLIERS[level]
	max_vehicles = 2 + floor(distance / 450.0) + floor(level / 2.0)
	max_workers = 6
	sprite = SPRITES[level]
	inactive_sprite = INACTIVE_SPRITES[level]
	cost = int(distance) * 5 * int(LEVEL_MULTIPLIERS[level])

func get_road_cost():
	return cost 

func get_title():
	return TITLES[level] if active else "%s (Inactive)" % TITLES[level]

func get_image():
	return sprite if active else inactive_sprite

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
			"title": "%s (%s)" % ["Build road" if level == 0 else "Secure route", Utils.format_gold(get_road_cost())],
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
