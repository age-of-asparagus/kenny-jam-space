extends Node

var max_fuel := 100.0
var fuel := max_fuel


var max_boosts = 10
var boosts_available = max_boosts

func reset():
	fuel = max_fuel
	boosts_available = max_boosts
