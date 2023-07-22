extends Node2D

export var sectors := 10
export var sector_size := 2048
export var planet_density := 0.5  # probability of generating a planet in that sector

var Planet : PackedScene = preload("res://World/Planet.tscn")

const PLANET_PATH = "res://Assets/kenney_planets/Planets/planet0"  # + #.png
const NUM_PLANET_TEXTURES = 10
var planet_textures = []


func _ready():
	load_planet_textures()
	generate_planets()
	
func load_planet_textures():
	for i in range(NUM_PLANET_TEXTURES):
		# res://Assets/kenney_planets/Planets/planet00.png etc.
		planet_textures.append(PLANET_PATH + str(i) + ".png")
	
func generate_planets():
	# place a planet randomly within each "sector" where a sector.
	var top_left = -sectors * sector_size / 2
#	var origin = Vector2(top_left, top_left)
	for x in range(sectors):
		for y in range(sectors):
			if randf() < planet_density:
				var planet : Planet = Planet.instance()
				# a random location within the sector
				planet.global_position = Vector2(
					randi()%sector_size + x*sector_size + top_left,
					randi()%sector_size + y*sector_size + top_left
				)
				add_child(planet)
				
	# genreate the mini map and other stuff the HUD does once planets are created
	$CanvasLayer/HUD.initialize_HUD()
