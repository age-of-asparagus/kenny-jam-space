extends Control


onready var fuel_bar = $MarginContainer/FuelProgress


# Called when the node enters the scene tree for the first time.
func _ready():
	fuel_bar.value = Global.max_fuel


func _process(change):
	fuel_bar.value = Global.fuel
