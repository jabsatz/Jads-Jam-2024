extends Node2D

var UPGRADES = [[
	Upgrade.new("Steel pickaxes", "Increases miner speed", 5000.0, func(): upgrade_miners(2)),
	Upgrade.new("Improved trucks", "Increases trucks speed and cargo", 5000.0, func(): upgrade_vehicles(2)),
	Upgrade.new("REALLY cool sunglasses", "REALLY improves your style", 15000.0, func(): upgrade_style())
], [
	Upgrade.new("Water-resistant pickaxes", "Increases miner speed", 10000.0, func(): upgrade_miners(2)),
	Upgrade.new("Improved ships", "Increases ship speed and cargo", 10000.0, func(): upgrade_vehicles(2)),
	Upgrade.new("REALLY cool cigar", "REALLY improves your style", 100000.0, func(): upgrade_style())
], [
	Upgrade.new("Supersonic jackhammers", "Increases miner speed", 25000.0, func(): upgrade_miners(2)),
	Upgrade.new("Improved planes", "Increases plane speed and cargo", 25000.0, func(): upgrade_vehicles(2)),
	Upgrade.new("REALLY cool tophat", "REALLY improves your style", 750000.0, func(): upgrade_style())
], [
	Upgrade.new("Heaven-piercing drills", "Increases drill speed", 5000000.0, func(): upgrade_miners(2)),
	Upgrade.new("Improved rockets", "Increases rocket speed and cargo", 5000000.0, func(): upgrade_vehicles(2)),
	Upgrade.new("BUY THE PLANET", "REALLY improves your style", 1000000000.0, func(): win_game())
]]

const BACKGROUND_COLOR : Array[Color] = [Color("#366947"), Color("1d5269"), Color("266956"), Color("080808")]

const WORKER_BASE_PRICES : Array[float] = [200.0, 800.0, 5000.0, 30000.0]
const VEHICLE_BASE_PRICES : Array[float] = [400.0, 1600.0, 10000.0, 60000.0]

@onready var background : ColorRect = %Background
@onready var tick_timer : Timer = %TickTimer
@onready var dragon : Node2D = %Dragon
var MineScene : PackedScene = load("res://entities/mine.tscn")

var level := GameManager.level
var gold := GameManager.starting_gold

var mines : Array[Mine] = [
	Mine.new(400.0, level, true),
	Mine.new(450.0, level),
	Mine.new(500.0, level),
	Mine.new(600.0, level),
	Mine.new(600.0, level),
	Mine.new(600.0, level),
	Mine.new(900.0, level),
	Mine.new(900.0, level),
	Mine.new(900.0, level),
	Mine.new(1000.0, level),
	Mine.new(1000.0, level),
]
var vehicle_multiplier = 1.0
var miner_multiplier = 1.0

var workers : Array[Worker] = [Worker.new(level, miner_multiplier), Worker.new(level, miner_multiplier)]
var vehicles : Array[Vehicle] = [Vehicle.new(level, vehicle_multiplier)]

var available_upgrades : Array = UPGRADES[level]

var worker_price := WORKER_BASE_PRICES[level]
var vehicle_price := VEHICLE_BASE_PRICES[level]

func _ready() -> void:
	GameManager.game_scene = self
	background.color = BACKGROUND_COLOR[level]
	
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
	workers.append(Worker.new(level))

func buy_vehicle():
	if gold < vehicle_price:
		return
	gold -= vehicle_price
	vehicles.append(Vehicle.new(level, vehicle_multiplier))

func execute_upgrade(i: int):
	var upgrade : Upgrade = available_upgrades[i]
	if gold < upgrade.cost:
		return
	gold -= upgrade.cost
	upgrade.effect.call()
	available_upgrades.pop_at(i)

func upgrade_miners(mult: float):
	for worker in workers:
			worker.speed *= mult
	for mine in mines:
		for worker in mine.workers:
			worker.speed *= mult
	miner_multiplier *= mult

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
	vehicle_multiplier *= mult

func upgrade_style():
	GameManager.camera.center_on_position(dragon.position, 1.0)
	await GameManager.camera.animation_complete
	GameManager.camera.move_enabled = false
	dragon.upgrade()
	SceneManager.reload_scene({ "pattern": "circle", "color": Color.WHITE, "invert_on_leave": false })
	GameManager.starting_gold = gold
	GameManager.level += 1

func win_game():
	GameManager.camera.center_on_position(dragon.position, 1.0)
	await GameManager.camera.animation_complete
	GameManager.camera.move_enabled = false
	SceneManager.change_scene("res://scenes/end_screen.tscn", { "pattern": "circle", "color": Color.WHITE, "invert_on_leave": false })
	GameManager.starting_gold = 0.0
	GameManager.level = 0

func _on_tick_timer_timeout() -> void:
	tick()
	tick_timer.start()
