extends Line2D

var VehicleScene : PackedScene = load("res://entities/vehicle.tscn")

var mine : Mine
var start : Vector2
var end : Vector2
var path :Path2D

func setup(_mine: Mine, _start: Vector2, _end: Vector2) -> void:
	mine = _mine
	start = _start
	end = _end
	add_point(start)
	add_point(end)
	path = Path2D.new()
	path.curve = Curve2D.new()
	path.curve.add_point(start)
	path.curve.add_point(end)
	add_child(path)
	mine.road = self

func add_vehicle(vehicle: Vehicle):
	vehicle.node = VehicleScene.instantiate()
	vehicle.node.resource = vehicle
	var path_follow = PathFollow2D.new()
	path_follow.rotates = false
	path_follow.loop = false
	path.add_child(path_follow)
	path_follow.add_child(vehicle.node)

func process_vehicles():
	for path_follow : PathFollow2D in path.get_children():
		var vehicle_node = path_follow.get_child(0)
		var vehicle : Vehicle = vehicle_node.resource
		if vehicle.status == "going":
			path_follow.progress += vehicle.speed
			vehicle.progress = path_follow.progress_ratio
			vehicle_node.look_to(mine.direction)
			if path_follow.progress_ratio >= 1.0:
				path_follow.progress_ratio = 1.0
				vehicle.status = "loading"
		elif vehicle.status == "returning":
			path_follow.progress -= vehicle.speed
			vehicle.progress = path_follow.progress_ratio
			vehicle_node.look_to(mine.direction * -1)
			if path_follow.progress_ratio <= 0.0:
				path_follow.progress_ratio = 0.0
				vehicle.status = "unloading"