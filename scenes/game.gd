extends Node2D

@onready var tick_timer : Timer = %TickTimer
@onready var dragon : Node2D = %Dragon
var Truck : Vehicle = load("res://resources/vehicles/truck.tres")
var Miner : Worker = load("res://resources/workers/miner.tres")
var VehicleScene : PackedScene = load("res://entities/vehicle.tscn")
var MineScene : PackedScene = load("res://entities/mine.tscn")
var RoadLine : PackedScene = load("res://entities/road_line.tscn")

var gold := 0.0
var mines : Array[Mine] = [
	Mine.new(400.0, true),
	Mine.new(450.0),
	Mine.new(500.0),
	Mine.new(600.0),
	Mine.new(600.0),
	Mine.new(600.0),
	Mine.new(900.0),
	Mine.new(900.0),
	Mine.new(900.0),
	Mine.new(1000.0),
	Mine.new(1000.0),
]
var workers : Array[Worker] = [Miner.duplicate(), Miner.duplicate()]
var vehicles : Array[Vehicle] = [Truck.duplicate()]

var available_upgrades : Array[Upgrade] = [
	Upgrade.new("Steel pickaxes", "Increases mine's yield", 20000.0, func(): upgrade_mines(1.5)),
	Upgrade.new("Improved trucks", "Increases trucks speed and cargo", 20000.0, func(): upgrade_vehicles(1.5)),
	Upgrade.new("REALLY cool sunglasses", "REALLY improves your style", 50000.0, func(): upgrade_style())
]

var worker_price := 200.0
var vehicle_price := 400.0

func _ready() -> void:
	GameManager.game_scene = self
	
	for mine in mines:
		var mine_node :Node2D = MineScene.instantiate()
		mine.node = mine_node
		mine_node.position = dragon.position + mine.direction * mine.distance
		add_child(mine_node)
		mine_node.setup(mine)
		if mine.active:
			mine_node.assign_worker()
			mine_node.assign_worker()
			mine_node.assign_vehicle()			
	tick_timer.start()

func tick() -> void:
	process_mines()

func process_mines():
	for mine in mines:
		mine.node.process_mine()

func buy_worker():
	if gold < worker_price:
		return
	gold -= worker_price
	workers.append(Miner.duplicate())

func buy_vehicle():
	if gold < vehicle_price:
		return
	gold -= vehicle_price
	vehicles.append(Truck.duplicate())

func execute_upgrade(i: int):
	var upgrade = available_upgrades[i]
	if gold < upgrade.cost:
		return
	gold -= upgrade.cost
	upgrade.effect.call()
	available_upgrades.pop_at(i)

func upgrade_mines(mult: float):
	for mine in mines:
		mine.gold_yield *= mult

func upgrade_vehicles(mult: float):
	for vehicle in vehicles:
		vehicle.speed *= mult
		vehicle.loading_speed *= mult
		vehicle.capacity *= mult
	for mine in mines:
		for vehicle in mine.vehicles:
			vehicle.speed *= mult
			vehicle.loading_speed *= mult
			vehicle.capacity *= mult
	Truck.speed *= mult
	Truck.loading_speed *= mult
	Truck.capacity *= mult

func upgrade_style():
	GameManager.camera.center_on_position(dragon.position, 1.0)
	await GameManager.camera.animation_complete
	GameManager.camera.move_enabled = false
	dragon.upgrade()
	SceneManager.change_scene("res://scenes/level2.tscn", { "pattern": "circle", "color": Color.WHITE, "invert_on_leave": false })

func _on_tick_timer_timeout() -> void:
	tick()
	tick_timer.start()
