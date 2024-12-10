class_name Vehicle
extends Resource

const LEVEL_VALUES = [{
	"name": "Truck",
	"speed": 50.0,
	"loading_speed": 50.0,
	"capacity": 500.0,
	"icon": preload("res://assets/truck.svg"),
},{
	"name": "Ship",
	"speed": 100.0,
	"loading_speed": 150.0,
	"capacity": 1000.0,
	"icon": preload("res://assets/cargo_ship.svg"),
},{
	"name": "Plane",
	"speed": 100.0,
	"loading_speed": 2000.0,
	"capacity": 15000.0,
	"icon": preload("res://assets/cargo_plane.svg"),
},{
	"name": "Rocket",
	"speed": 100.0,
	"loading_speed": 7500.0,
	"capacity": 75000.0,
	"icon": preload("res://assets/cargo_rocket.svg"),
}]

@export var name:String
@export var speed:float
@export var loading_speed:float
@export var capacity:float
@export var icon:Texture2D
var progress : float = 0.0
var status : String = "going"
var cargo_load : float = 0.0
var level : float
var node : Node

func _init(_level : int = 0, _mult : float = 1.0) -> void:
	level = _level
	var values = LEVEL_VALUES[level]
	name = values["name"]
	speed = values["speed"] * _mult
	loading_speed = values["loading_speed"] * _mult
	capacity = values["capacity"] * _mult
	icon = values["icon"]

func get_title():
	return name

func get_image():
	return icon

func get_user_friendly_speed():
	var level_multipliers := [1, 5, 10, 1000]
	return Utils.format_amount(speed * level_multipliers[level])

func get_description():
	var description = """Brings gold back from mines.

Capacity: [b]{capacity}[/b]
Road speed: [b]{speed}km/h[/b]
Loading speed: [b]{loading_speed} per tick[/b]"""
	return description.format({ "capacity": Utils.format_gold(capacity), "speed": get_user_friendly_speed(), "loading_speed": Utils.format_gold(loading_speed) })