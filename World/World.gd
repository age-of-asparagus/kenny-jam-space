extends Node2D

export var galaxy_size := 1000
export var planet_density := 0.02

var Planet : PackedScene = preload("res://World/Planet.tscn")

const PLANET_PATH = "res://Assets/kenney_planets/Planets/planet0"  # + #.png
const NUM_PLANET_TEXTURES = 10
var planet_textures = []

func _ready():
	load_planet_textures()
	generate_planets()
	
func _process(delta):
	if Input.is_action_pressed("ui_accept"):
		$CanvasLayer/HUD.update_fuel(-0.01)
	
func load_planet_textures():
	for i in range(NUM_PLANET_TEXTURES):
		# res://Assets/kenney_planets/Planets/planet00.png etc.
		planet_textures.append(PLANET_PATH + str(i) + ".png")
	
func generate_planets():
	pass
