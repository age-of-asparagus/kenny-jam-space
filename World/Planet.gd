extends Area2D

class_name Planet

export var mystery_planet : Texture
export var colonized_planet : Texture

var colonized = false

signal too_fast
signal proximity
signal proximity_exited
signal colonized
signal message
signal game_over

func _ready():
	$Sprite.texture = mystery_planet
	

func _on_ProximitySensor_body_entered(body):
	emit_signal("proximity", self)

func _on_ProximitySensor_body_exited(body):
	emit_signal("proximity_exited", self)

func _on_Planet_body_entered(body: PhysicsBody2D):
	if not colonized:
		if body.velocity.length() < 40:
			$Sprite.texture = colonized_planet
			Global.fuel = min(Global.fuel + 10, Global.max_fuel)
			Global.boosts_available += 1
			colonized = true
			$Satellites.visible = true
			emit_signal("colonized", self)

			
func game_over(reason : String):
	emit_signal("message", "GAME OVER\nYOU CRASHED", -1)
	emit_signal("game_over")
	
