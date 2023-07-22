extends Control


onready var fuel_bar = $VBoxContainer/MarginContainer/FuelProgress
onready var booster_bar = $VBoxContainer/MarginContainer2/BoostBar


# Called when the node enters the scene tree for the first time.
func _ready():
	fuel_bar.value = Global.max_fuel

func _process(change):
	fuel_bar.value = Global.fuel


	for i in booster_bar.get_child_count():
		var icon : TextureRect = booster_bar.get_child(i)
		icon.visible = (Global.warps_available > i)
