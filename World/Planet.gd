extends Area2D

class_name Planet

export var mystery_planet : Texture
export var colonized_planet : Texture

var colonized = false

signal too_fast
signal proximity
signal proximity_exited
signal colonized

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
		else:
			$Explosion.global_position = body.global_position
			body.visible = false
			body.set_process(false)
			body.set_physics_process(false)
			$Explosion/AnimationPlayer.play("Explode")
			game_over("Crashed")
			
func game_over(reason : String):
	pass
	
