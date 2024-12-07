class_name Vehicle
extends Resource

@export var name:String
@export var speed:float
@export var loading_speed:float
@export var capacity:float
@export var icon:Texture2D
var progress : float = 0.0
var status : String = "idle"
var cargo_load : float = 0.0
var node : Node