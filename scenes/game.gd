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
var workers : Array[Worker] = []
var vehicles : Array[Vehicle] = []

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
		mine.node = mine_node
		mine_node.position = dragon.position + mine.direction * mine.distance
		add_child(mine_node)
		mine_node.setup(mine)
	tick_timer.start()

func tick() -> void:
	process_mines()

func process_mines():
	for mine in mines:
		mine.node.process_mine()
		

func _on_tick_timer_timeout() -> void:
	tick()
	tick_timer.start()
