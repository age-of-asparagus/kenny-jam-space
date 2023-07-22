extends Control


export (NodePath) var player

onready var fuel_bar = $VBoxContainer/MarginContainer/FuelProgress
onready var booster_bar = $VBoxContainer/MarginContainer2/BoostBar

onready var minimap = $MarginContainer/NinePatchRect/Minimap/
onready var player_marker = $MarginContainer/NinePatchRect/Minimap/PlayerMarker
onready var planet_marker = $MarginContainer/NinePatchRect/Minimap/DotGreen

var zoom = 5
var map_scale
var markers = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	fuel_bar.value = Global.max_fuel
	
	player_marker.position = minimap.rect_size / 2
	map_scale = minimap.rect_size / (get_viewport_rect().size * zoom)
#	update_mini_map()

func _process(change):
	
	fuel_bar.value = Global.fuel
	for i in booster_bar.get_child_count():
		var icon : TextureRect = booster_bar.get_child(i)
		icon.visible = (Global.warps_available > i)
		
	if !player:
		return
		
	player_marker.rotation = get_node(player).rotation
	
	for item in markers:
		var obj_pos = (item.position - get_node(player).position) * map_scale + minimap.rect_size / 2

		if minimap.get_rect().has_point(obj_pos):
			markers[item].show()
		else:
			markers[item].hide()
			
		obj_pos.x = clamp(obj_pos.x, 0, minimap.rect_size.x)
		obj_pos.y = clamp(obj_pos.y, 0, minimap.rect_size.y)
		markers[item].position = obj_pos
		
		
func update_mini_map():
	markers = {}
	var map_objects := get_tree().get_nodes_in_group("minimap_objects")
	print(map_objects.size())
	for item in map_objects:
		var new_marker = planet_marker.duplicate()
		minimap.add_child(new_marker)
		new_marker.show()
		markers[item] = new_marker
		
