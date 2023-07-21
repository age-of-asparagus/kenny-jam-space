extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const SPEED := 10


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var	direction := Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	position += direction * SPEED
	
