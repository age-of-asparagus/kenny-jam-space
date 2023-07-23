extends Area2D

var speed = 15

func _physics_process(delta):
	global_position += Vector2(speed,0).rotated(rotation - deg2rad(90))


func _on_disappear_timer_timeout():
	queue_free()
