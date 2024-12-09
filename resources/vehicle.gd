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
	"loading_speed": 200.0,
	"capacity": 1500.0,
	"icon": preload("res://assets/cargo_plane.svg"),
},{
	"name": "Rocket",
	"speed": 100.0,
	"loading_speed": 300.0,
	"capacity": 2000.0,
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

func get_user_friendly_status():
	match status:
		"going":
			return "Travelling to mine"
		"loading":
			return "Loading gold"
		"returning":
			return "Returning to base"
		"unloading":
			return "Unloading gold"

func get_description():
	var description = """Brings gold back from mines.

Status: [b]{status}[/b]
Cargo: [b]{cargo_load}/{capacity}[/b]
Road speed: [b]{speed}km/h[/b]
Loading speed: [b]{loading_speed}G per tick[/b]"""
	return description.format({ "status": get_user_friendly_status(), "cargo_load": "%d" % cargo_load, "capacity": "%d" % capacity, "speed": speed, "loading_speed": loading_speed })