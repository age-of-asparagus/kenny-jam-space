extends Area2D

var can_shoot = true
var Bullet = preload("res://enemy_bullet.tscn")
var player_detected = false
onready var player = get_parent().get_node("space_ship")

func _physics_process(delta):
	
	if not Global.player_alive:
		set_process(false)
		set_physics_process(false)
	
	if $Detect_player.get_overlapping_bodies():
		player_detected = true
	else:
		player_detected = false
	
	
	if player_detected:
		$red_planet/gun_base/gun.look_at(player.global_position)
		$red_planet/gun_base/gun.rotation -= deg2rad(90)
		if can_shoot:
			can_shoot = false
			$fire_rate.start()


func _on_fire_rate_timeout():
	$Shoot.play()
	var bullet = Bullet.instance()
	bullet.global_position = $red_planet/gun_base/gun/bullet_spawn.global_position
	bullet.global_rotation = $red_planet/gun_base/gun.global_rotation
	get_parent().add_child(bullet)
	can_shoot = true


func _on_bad_planet_area_entered(area):
	$Explode.play()
	set_process(false)
	set_physics_process(false)
	Global.bad_destroyed_planets += 1
	$AnimationPlayer.play("explode")
	yield($AnimationPlayer,"animation_finished")
	queue_free()
