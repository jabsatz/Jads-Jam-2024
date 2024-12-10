class_name Worker
extends Resource

const LEVEL_VALUES = [{
	"name": "Miner",
	"speed": 0.25,
	"icon": preload("res://assets/miner.svg"),
}, {
	"name": "Scuba miner",
	"speed": 0.5,
	"icon": preload("res://assets/scuba_miner.svg"),
}, {
	"name": "Jackhammer miner",
	"speed": 1.0,
	"icon": preload("res://assets/jackhammer_miner.svg"),
}, {
	"name": "Heaven-piercing Drill",
	"speed": 2.0,
	"icon": preload("res://assets/heaven_piercing_drill.svg"),
}]

@export var name:String
@export var speed:float
@export var icon:Texture2D
var level: int

func _init(_level: int, mult: float = 1.0) -> void:
	level = _level
	var values = LEVEL_VALUES[level]
	name = values["name"]
	speed = values["speed"] * mult
	icon = values["icon"]

func get_title():
	return name

func get_image():
	return icon

func get_description():
	var description = """Mines gold from {mining_place}.

Mining speed: [b]{speed} * {mining_place} yield per tick[/b]"""
	return description.format({ "mining_place": "mines" if level < 3 else "asteroids", "speed": speed })
