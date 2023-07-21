extends Control


var fuel = 100

onready var fuel_bar = $MarginContainer/FuelProgress


# Called when the node enters the scene tree for the first time.
func _ready():
	fuel_bar.value = fuel


func update_fuel(change):
	fuel += change
	fuel_bar.value = fuel
