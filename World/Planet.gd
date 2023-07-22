extends Area2D

signal too_fast

func _ready():
	pass # Replace with function body.

func _on_ProximitySensor_body_entered(body):
	if body.velocity.length() < 100:
		print("PLANET CAPTURED!")
	else:
		emit_signal("too_fast")
