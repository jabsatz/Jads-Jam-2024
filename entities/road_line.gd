extends Line2D

var VehicleScene : PackedScene = load("res://entities/vehicle.tscn")
var RoadIcon = load("res://assets/road_64.svg")

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
	%CollisionShape2D.shape.height = (end - start).length()
	%CollisionShape2D.rotation = mine.direction.angle() - (PI / 2.0)
	%CollisionShape2D.position = start + mine.direction * (end - start).length() / 2.0
	mine.road = self

func add_vehicle(vehicle: Vehicle):
	vehicle.node = VehicleScene.instantiate()
	vehicle.node.resource = vehicle
	var path_follow = PathFollow2D.new()
	path_follow.rotates = false
	path_follow.loop = false
	path.add_child(path_follow)
	path_follow.add_child(vehicle.node)

func remove_vehicle(_vehicle: Vehicle):
	for path_follow : PathFollow2D in path.get_children():
		var vehicle_node = path_follow.get_child(0)
		var vehicle : Vehicle = vehicle_node.resource
		if vehicle == _vehicle:
			_vehicle.cargo_load = 0.0
			_vehicle.progress = 0.0
			path_follow.queue_free()

func _physics_process(delta):
	for path_follow : PathFollow2D in path.get_children():
		var vehicle_node = path_follow.get_child(0)
		var vehicle : Vehicle = vehicle_node.resource
		if vehicle.status == "going":
			path_follow.progress += vehicle.speed * delta
			vehicle.progress = path_follow.progress_ratio
			vehicle_node.look_to(mine.direction)
			if path_follow.progress_ratio >= 1.0:
				path_follow.progress_ratio = 1.0
				vehicle.status = "loading"
		elif vehicle.status == "returning":
			path_follow.progress -= vehicle.speed * delta
			vehicle.progress = path_follow.progress_ratio
			vehicle_node.look_to(mine.direction * -1)
			if path_follow.progress_ratio <= 0.0:
				path_follow.progress_ratio = 0.0
				vehicle.status = "unloading"


# func _on_area_2d_mouse_entered() -> void:
# 	if not GameManager.ui.info_is_pinned:
# 		GameManager.ui.show_info(
# 			"Road",
# 			RoadIcon,
# 			("""This road connects the mines to the dragon.

# Vehicles active: [b]{vehicles}[/b]
# Length: [b]{length}km[/b]""").format({ "vehicles": "%d" % path.get_child_count(), "length": "%d" % mine.distance })
# 		)

# func _on_area_2d_mouse_exited() -> void:
# 	if not GameManager.ui.info_is_pinned:
# 		GameManager.ui.hide_info()
