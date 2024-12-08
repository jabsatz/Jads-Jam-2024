extends Node2D

@onready var tick_timer : Timer = %TickTimer
@onready var dragon : Node2D = %Dragon
var Truck : Vehicle = load("res://resources/vehicles/truck.tres")
var Miner : Worker = load("res://resources/workers/miner.tres")
var VehicleScene : PackedScene = load("res://entities/vehicle.tscn")
var MineScene : PackedScene = load("res://entities/mine.tscn")
var RoadLine : PackedScene = load("res://entities/road_line.tscn")

var gold := 10000.0
var mines : Array[Mine] = []
var workers : Array[Worker] = [Miner.duplicate(), Miner.duplicate()]
var vehicles : Array[Vehicle] = [Truck.duplicate()]

var worker_price := 200.0
var vehicle_price := 400.0

func _ready() -> void:
	GameManager.game_scene = self
	var starter_mine = Mine.new()
	starter_mine.active = true
	starter_mine.distance = 400.0
	mines.append(starter_mine)

	for i in range(10):
		mines.append(Mine.new())
	
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

func _on_tick_timer_timeout() -> void:
	tick()
	tick_timer.start()
