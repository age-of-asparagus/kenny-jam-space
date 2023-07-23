extends KinematicBody2D

var boost_vector : Vector2
var boost = 10
var boosting = false
var can_shoot = true
var rotate_acceleration = 0.0005
var velocity := Vector2.ZERO  
export var acceleration = 2
export var rotation_speed = 0
var Bullet = preload("res://World/player_bullet.tscn")

func _ready():
	$Move_sound.playing = true
	$Rotate_sound.playing = true
	$Move_sound.stream_paused = true
	$Rotate_sound.stream_paused = true
func _physics_process(delta):
	get_tree().get_nodes_in_group("colonized")
	
	if Input.is_action_just_pressed("boost") and not boosting and Global.boosts_available > 0 and Global.fuel > 0:
		$AnimationPlayer.play("boost")
		boosting = true
		Global.boosts_available -= 1
		boost_vector = -transform.y
		$Move_sound.stream_paused = false
		$boost_timer.start()

	
	if Input.is_action_pressed("move") and not boosting and Global.fuel > 0:
		Global.fuel -= 0.015
		velocity += -transform.y * acceleration
		$Move_sound.stream_paused = false
		$ship/Fire.play("moving")
		$ship/Fire.scale = Vector2(1.5,1.5)
	elif boosting and Global.fuel > 0:
		Global.fuel -= 0.08
		velocity += -transform.y * acceleration * boost
		$ship/Fire.scale = Vector2(2,2)
		$ship/Fire.play("boosting")

	else:
		$ship/Fire.scale = Vector2(1.5,1.5)
		$ship/Fire.play("idle")
		$Move_sound.stream_paused = true
	
	
	
	var rotation_dir = Input.get_axis("rotate_left", "rotate_right")
	
	if rotation_dir > 0 and Global.fuel > 0:
		Global.fuel -= 0.002
		rotation_speed += rotate_acceleration
		$Right_booster.play("idle")
		$Left_booster.play("boost")
		$Rotate_sound.stream_paused = false
	elif rotation_dir < 0 and Global.fuel > 0:
		Global.fuel -= 0.002
		rotation_speed -= rotate_acceleration
		$Rotate_sound.stream_paused = false
		$Left_booster.play("idle")
		$Right_booster.play("boost")
	else:
		$Rotate_sound.stream_paused = true
		$Right_booster.play("idle")
		$Left_booster.play("idle")
	rotate(rotation_speed)
	move_and_slide(velocity)
	
	if Input.is_action_pressed("shoot") and can_shoot:
		can_shoot = false
		shoot()
	

func shoot():
	$Shoot.play()
	var bullet = Bullet.instance()
	bullet.global_position = $Bullet_spawn.global_position
	bullet.global_rotation = $ship.global_rotation
	get_parent().add_child(bullet)
	$fire_rate.start()


func die():
	Global.player_alive = false
	set_process(false)
	set_physics_process(false)
	$Rotate_sound.stream_paused = true
	$Move_sound.stream_paused = true
	$ship.visible = false


func _on_boost_timer_timeout():
	boosting = false

func Explode():
	$Explosion/AnimationPlayer.play("Explode")
	$Explosion/Explosion.play("explode")
	die()


func _on_Area2D_area_entered(area):
	area.queue_free()
	Explode()




func _on_fire_rate_timeout():
	can_shoot = true
