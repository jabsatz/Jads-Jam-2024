extends Node2D

@onready var tick_timer : Timer = %TickTimer
@onready var dragon : Node2D = %Dragon
var Truck : Vehicle = load("res://resources/vehicles/truck.tres")
var Miner : Worker = load("res://resources/workers/miner.tres")
var VehicleScene : PackedScene = load("res://entities/vehicle.tscn")
var MineScene : PackedScene = load("res://entities/mine.tscn")
var RoadLine : PackedScene = load("res://entities/road_line.tscn")

var gold := 100.0
var mines : Array[Mine] = []

func _ready() -> void:
	GameManager.game_scene = self
	var starter_mine = Mine.new()
	starter_mine.active = true
	var starter_vehicles : Array[Vehicle] = [Truck.duplicate()]
	starter_mine.vehicles = starter_vehicles
	var starter_workers : Array[Worker] = [Miner.duplicate(), Miner.duplicate()]
	starter_mine.workers = starter_workers
	starter_mine.distance = 400.0
	mines.append(starter_mine)

	for i in range(10):
		mines.append(Mine.new())
	
	for mine in mines:
		var mine_node :Node2D = MineScene.instantiate()
		mine_node.setup(mine)
		mine_node.position = dragon.position + mine.direction * mine.distance
		add_child(mine_node)
		mine.node = mine_node
		if mine.active:
			var road_node : Line2D = RoadLine.instantiate()
			road_node.setup(mine, dragon.position + mine.direction * 100, mine_node.position - mine.direction * 40)
			add_child(road_node)
	tick_timer.start()

func tick() -> void:
	process_mines()

func process_mines():
	for mine in mines:
		if not mine.active:
			continue

		for worker in mine.workers:
			worker.progress += worker.speed
			if worker.progress >= 1.0:
				worker.progress -= 1.0
				mine.storage += mine.gold_yield
		
		mine.road.process_vehicles()
		
		for vehicle in mine.vehicles:
			match vehicle.status:
				'idle':
					vehicle.status = 'going'
					vehicle.progress = 0.0
					mine.road.add_vehicle(vehicle)
				'loading':
					var amount_to_load = min(vehicle.loading_speed, mine.storage, vehicle.capacity - vehicle.cargo_load)
					vehicle.cargo_load += amount_to_load
					mine.storage -= amount_to_load
					if vehicle.cargo_load >= vehicle.capacity:
						vehicle.status = "returning"
				'unloading':
					var amount_to_unload = min(vehicle.loading_speed, vehicle.cargo_load)
					vehicle.cargo_load -= amount_to_unload
					gold += amount_to_unload
					if vehicle.cargo_load <= 0.0:
						vehicle.status = "going"
		

func _on_tick_timer_timeout() -> void:
	tick()
	tick_timer.start()
