extends Control

export (NodePath) var player

onready var fuel_bar = $VBoxContainer/MarginContainer/FuelProgress
onready var booster_bar = $VBoxContainer/MarginContainer2/BoostBar

onready var warning_label_player = $WarningContainer/WarningLabel/AnimationPlayer

onready var minimap = $MarginContainer/NinePatchRect/Minimap/
onready var player_marker = $MarginContainer/NinePatchRect/Minimap/PlayerMarker
onready var colonized_planet_marker = $MarginContainer/NinePatchRect/Minimap/DotGreen
onready var unknown_planet_marker = $MarginContainer/NinePatchRect/Minimap/DotRed

export var danger_sound : AudioStream = preload("res://Assets/kenney_sci-fi-sounds/Audio/forceField_000.ogg")
export var discovery_sound : AudioStream = preload("res://Assets/kenney_sci-fi-sounds/Audio/laserRetro_003.ogg")
export var colonized_sound : AudioStream = preload("res://Assets/kenney_sci-fi-sounds/Audio/slime_001.ogg")

var zoom = 5
var map_scale
var markers = {}
var planets = []

var proximity_object : Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	fuel_bar.value = Global.max_fuel
	stop_warning()
	
	player_marker.position = minimap.rect_size / 2
	map_scale = minimap.rect_size / (get_viewport_rect().size * zoom)

func _process(change):
	
	# update fuel bar
	fuel_bar.value = Global.fuel
	for i in booster_bar.get_child_count()-1:  # the first one is a label, so skip it
		var icon : TextureRect = booster_bar.get_child(i+1)
		icon.visible = (Global.boosts_available > i)
		
	# Update Minimap
	if !player:
		return
	var player_node = get_node(player)
	
	if !player_node:  # just in case player is queue_freed
		return
		
	# Update speed
	var speed = player_node.velocity.length()
	$Label.text = str(int(speed)) + " km/s"
#	if speed < 40:
#		stop_warning()
	
	# Update minimap
	player_marker.rotation = player_node.rotation
	
	for item in markers:
		var obj_pos = (item.position - get_node(player).position) * map_scale + minimap.rect_size / 2

		if minimap.get_rect().has_point(obj_pos):
			if item.is_in_group("colonized"):
				markers[item].modulate = Color("00ff88")
			markers[item].show()
		else:
			markers[item].hide()
			
		obj_pos.x = clamp(obj_pos.x, 0, minimap.rect_size.x)
		obj_pos.y = clamp(obj_pos.y, 0, minimap.rect_size.y)
		markers[item].position = obj_pos
		
		
func initialize_HUD():
	
	# Init minimap with planets and player
	markers = {}
	var map_objects := get_tree().get_nodes_in_group("minimap_objects")
	var new_marker
	for item in map_objects:
		new_marker = unknown_planet_marker.duplicate()
		minimap.add_child(new_marker)
		new_marker.show()
		markers[item] = new_marker
		
	# Connect to proximity signals for planets
	for planet in get_tree().get_nodes_in_group("planets"):
		planet.connect("proximity", self, "_on_Planet_proximity")
		planet.connect("proximity_exited", self, "_on_Planet_proximity_exited")
		planet.connect("colonized", self, "_on_Planet_colonized")
		
func _on_Planet_proximity(planet):
	var player_node = get_node(player)
	if player_node.velocity.length() > 40:
		display_warning()
	else: 
		display_discovery()

func _on_Planet_proximity_exited(planet):
	stop_warning()
	
func _on_Planet_colonized(planet):
	planet.disconnect("proximity", self, "_on_Planet_proximity")
	planet.disconnect("proximity_exited", self, "_on_Planet_proximity_exited")
	planet.disconnect("colonized", self, "_on_Planet_colonized")
	display_colonized()
	# wait a second before ending animation
	yield(get_tree().create_timer(1.0), "timeout")
	stop_warning()
	planet.add_to_group("colonized")

func display_colonized():
	$WarningContainer/WarningLabel.text = "PLANET COLONIZED"
	$WarningContainer.modulate = Color("00ff00")
	$WarningContainer/WarningLabel/AudioStreamPlayer.stream = colonized_sound
	warning_label_player.play("Flash")  # Danger proximity
		
func display_warning():
	$WarningContainer/WarningLabel.text = "PROXIMITY ALERT\nTOO FAST"
	$WarningContainer.modulate = Color("ff0000")
	$WarningContainer/WarningLabel/AudioStreamPlayer.stream = danger_sound
	warning_label_player.play("Flash")  # Danger proximity
	
func stop_warning():
	warning_label_player.play("RESET")
	
func display_discovery():
	$WarningContainer/WarningLabel.text = "SEFELY APPROCHING PLANET"
	$WarningContainer.modulate = Color("00ffff")
	$WarningContainer/WarningLabel/AudioStreamPlayer.stream = discovery_sound
	warning_label_player.play("Flash")
	
func display_message(message: String, seconds: float):
	pass
