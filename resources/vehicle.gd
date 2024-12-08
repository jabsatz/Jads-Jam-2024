class_name Vehicle
extends Resource

@export var name:String
@export var speed:float
@export var loading_speed:float
@export var capacity:float
@export var icon:Texture2D
var progress : float = 0.0
var status : String = "going"
var cargo_load : float = 0.0
var node : Node

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