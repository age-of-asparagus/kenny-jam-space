extends Area2D

export var mystery_planet : Texture
export var colonized_planet : Texture

var colonized = false

signal too_fast

func _ready():
	$Sprite.texture = mystery_planet
	

func _on_ProximitySensor_body_entered(body):
	print(body.velocity.length())
	if body.velocity.length() < 40 and not colonized:
		$Sprite.texture = colonized_planet
		Global.fuel = min(Global.fuel + 10, Global.max_fuel)
		Global.warps_available += 1
		colonized = true
		$CPUParticles2D.visible = true
	else:
		print("****************** TOO FAST! **********************")
		emit_signal("too_fast")
