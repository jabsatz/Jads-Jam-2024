extends Control

@onready var gold_label: Label = %GoldLabel
@onready var workers_label : Label = %WorkersLabel
@onready var worker_button : Button = %WorkerButton
@onready var vehicles_label : Label = %VehiclesLabel
@onready var vehicle_button : Button = %VehicleButton

@onready var info_container : Control = %InfoContainer
@onready var info_title_label : Label = %InfoTitleLabel
@onready var info_texture_rect : TextureRect = %InfoTextureRect
@onready var info_rich_text_label: RichTextLabel = %InfoRichTextLabel
@onready var info_action_buttons_container : Control = %InfoActionButtonsContainer
var resource_to_display = null
var info_is_pinned := false

func _ready():
	GameManager.ui = self
	info_container.visible = false
	worker_button.pressed.connect(buy_worker)
	vehicle_button.pressed.connect(buy_vehicle)

func buy_worker():
	GameManager.game_scene.buy_worker()

func buy_vehicle():
	GameManager.game_scene.buy_vehicle()


func _process(delta: float) -> void:
	gold_label.text = "%.2f" % GameManager.game_scene.gold
	workers_label.text = "%d" % GameManager.game_scene.workers.size()
	worker_button.text = "%dG" % GameManager.game_scene.worker_price
	worker_button.disabled = GameManager.game_scene.gold < GameManager.game_scene.worker_price 
	vehicles_label.text = "%d" % GameManager.game_scene.vehicles.size()
	vehicle_button.text = "%dG" % GameManager.game_scene.vehicle_price
	vehicle_button.disabled = GameManager.game_scene.gold < GameManager.game_scene.vehicle_price 

	if resource_to_display:
		show_info(resource_to_display.get_title(), resource_to_display.get_image(), resource_to_display.get_description(), true)
	if info_is_pinned:
		var action_buttons_data = resource_to_display.get_action_buttons()
		for button in info_action_buttons_container.get_children():
			var action_button_data = action_buttons_data.filter(func(d): return d["title"] == button.text).pop_front()
			if action_button_data and action_button_data.has("disabled"):
				button.disabled = action_button_data["disabled"]

func show_resource(resource):
	resource_to_display = resource

func show_info(title: String, image: Texture2D, description: String, keep_resource := false) -> void:
	info_container.visible = true
	if not keep_resource:
		resource_to_display = null
	info_title_label.text = title
	info_texture_rect.texture = image
	info_rich_text_label.text = description

func action_button_pressed():
	remove_action_buttons()
	show_action_buttons()


func show_action_buttons():
	var action_buttons_data = resource_to_display.get_action_buttons()
	for action_button_data in action_buttons_data:
		var button = Button.new()
		button.text = action_button_data["title"]
		if action_button_data.has("disabled"):
			button.disabled = action_button_data["disabled"]
		if action_button_data.has("tooltip"):
			button.tooltip_text = action_button_data["tooltip"]
		button.pressed.connect(action_button_data["action"])
		button.pressed.connect(action_button_pressed)
		info_action_buttons_container.add_child(button)

func remove_action_buttons():
	for child in info_action_buttons_container.get_children():
		child.queue_free()

func hide_info():
	if info_is_pinned:
		return
	remove_action_buttons()
	resource_to_display = null
	info_container.visible = false

func pin_resource(resource):
	info_is_pinned = true
	show_resource(resource)
	show_action_buttons()

func unpin_info():
	info_is_pinned = false
	hide_info()