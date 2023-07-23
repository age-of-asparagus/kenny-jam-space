extends Area2D

var speed = 5


func _physics_process(delta):
	global_position += Vector2(0,speed).rotated(rotation)


func _on_disappear_timer_timeout():
	queue_free()
