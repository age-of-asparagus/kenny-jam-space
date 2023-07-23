extends Node2D

export var sectors := 10
export var sector_size := 2048
export var planet_density := 0.5  # probability of generating a planet in that sector
var rng = RandomNumberGenerator.new()
var Planet : PackedScene = preload("res://World/Planet.tscn")
var Bad_Planet = preload("res://World/bad_planet.tscn")
const PLANET_PATH = "res://Assets/kenney_planets/Planets/planet0"  # + #.png
const NUM_PLANET_TEXTURES = 10
var planet_textures = []


func _ready():
	rng.randomize()
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
			if rng.randf() < planet_density:
				var planet : Planet = Planet.instance()
				var bad_planet = Bad_Planet.instance()
				# a random location within the sector
				if rng.randf_range(0,100) > 75:
					planet.global_position = Vector2(
					rng.randi()%sector_size + x*sector_size + top_left,
					rng.randi()%sector_size + y*sector_size + top_left
					)
					add_child(planet)
				else:
					bad_planet.global_position = Vector2(
					rng.randi()%sector_size + x*sector_size + top_left,
					rng.randi()%sector_size + y*sector_size + top_left
					)
					add_child(bad_planet)
	# genreate the mini map and other stuff the HUD does once planets are created
	$CanvasLayer/HUD.initialize_HUD()


func _on_HUD_reset_game():
	for planet in get_tree().get_nodes_in_group("planets"):
		planet.queue_free()
	Global.reset()
	_ready()
	$CanvasLayer/HUD._ready()
	$space_ship._ready()
	$space_ship.velocity = Vector2.ZERO
	$space_ship.rotation = 0.0
	$space_ship.rotation_speed = 0.0
	$space_ship.set_process(true)
	$space_ship.set_physics_process(true)
	$space_ship.global_position = Vector2.ZERO
	$space_ship.show()
	$CanvasLayer/HUD._ready()
