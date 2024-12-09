class_name Worker
extends Resource

const LEVEL_VALUES = [{
	"name": "Miner",
	"speed": 0.2,
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
var progress: float = 0.0
var level: int

func _init(_level) -> void:
	level = _level
	var values = LEVEL_VALUES[level]
	name = values["name"]
	speed = values["speed"]
	icon = values["icon"]
