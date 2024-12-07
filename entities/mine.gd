extends Area2D

var mine_sprite: Texture2D = load('res://assets/mine_64.svg')
var inactive_mine_sprite: Texture2D = load('res://assets/mine_inactive_64.svg')

var mine: Mine
var RoadLine: PackedScene = load("res://entities/road_line.tscn")


func setup(_mine):
	mine = _mine
	if mine.active:
		mine.active = false
		build_road(true)


func _process(delta):
	if mine.active:
		$Sprite2D.texture = mine_sprite
		$Label.text = "%d" % mine.storage
	if not mine.active:
		$Sprite2D.texture = inactive_mine_sprite
		$Label.text = ""


func process_mine():
	if not mine.active:
		return

	for worker in mine.workers:
		worker.progress += worker.speed
		if worker.progress >= 1.0:
			worker.progress -= 1.0
			mine.storage += mine.gold_yield

	mine.road.process_vehicles()

	for vehicle in mine.vehicles:
		match vehicle.status:
			'idle':
				vehicle.status = 'going'
				vehicle.progress = 0.0
				mine.road.add_vehicle(vehicle)
			'loading':
				var amount_to_load = min(
					vehicle.loading_speed, mine.storage, vehicle.capacity - vehicle.cargo_load
				)
				vehicle.cargo_load += amount_to_load
				mine.storage -= amount_to_load
				if vehicle.cargo_load >= vehicle.capacity:
					vehicle.status = "returning"
			'unloading':
				var amount_to_unload = min(vehicle.loading_speed, vehicle.cargo_load)
				vehicle.cargo_load -= amount_to_unload
				GameManager.game_scene.gold += amount_to_unload
				if vehicle.cargo_load <= 0.0:
					vehicle.status = "going"


func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if (
		event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
		and event.is_pressed()
	):
		GameManager.ui.pin_resource(mine)
		viewport.set_input_as_handled()


func _mouse_enter() -> void:
	if not GameManager.ui.info_is_pinned:
		GameManager.ui.show_resource(mine)


func _mouse_exit() -> void:
	if not GameManager.ui.info_is_pinned:
		GameManager.ui.hide_info()


func build_road(cost_free = false) -> void:
	if mine.active:
		return
	if not cost_free:
		GameManager.game_scene.gold -= mine.get_road_cost()
	mine.active = true
	var road_node: Line2D = RoadLine.instantiate()
	road_node.setup(
		mine,
		GameManager.game_scene.dragon.position + mine.direction * 100,
		position - mine.direction * 40
	)
	GameManager.game_scene.add_child(road_node)
	mine.road = road_node


func assign_worker() -> void:
	if not mine.active or GameManager.game_scene.workers.size() == 0:
		return
	var worker = GameManager.game_scene.workers.pop_back()
	mine.workers.append(worker)


func assign_vehicle() -> void:
	if not mine.active or GameManager.game_scene.vehicles.size() == 0:
		return
	var vehicle = GameManager.game_scene.vehicles.pop_back()
	mine.road.add_vehicle(vehicle)
	mine.vehicles.append(vehicle)


func unassign_worker() -> void:
	if not mine.active or mine.workers.size() == 0:
		return
	var worker = mine.workers.pop_back()
	GameManager.game_scene.workers.append(worker)


func unassign_vehicle() -> void:
	if not mine.active or mine.vehicles.size() == 0:
		return
	var vehicle = mine.vehicles.pop_back()
	mine.road.remove_vehicle(vehicle)
	GameManager.game_scene.vehicles.append(vehicle)
