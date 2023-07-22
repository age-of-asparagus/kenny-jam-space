extends KinematicBody2D

var boost_vector : Vector2
var boost = 50
var boosting = false


var velocity := Vector2.ZERO  
export var acceleration = 0.5  
export var rotation_speed = 0.05


func _ready():
	$AudioStreamPlayer.playing = true


func _physics_process(delta):
	
	
	if Input.is_action_just_pressed("boost") and not boosting and Global.boosts_available > 0:
		$AnimationPlayer.play("boost")
		boosting = true
		Global.boosts_available -= 1
		boost_vector = -transform.y
		$AudioStreamPlayer.stream_paused = false
		$boost_timer.start()

	
	if Input.is_action_pressed("move") and not boosting:
		Global.fuel -= 0.01
		velocity += -transform.y * acceleration
		$AudioStreamPlayer.stream_paused = false
		$Sprite/Fire.play("moving")
		$Sprite/Fire.scale = Vector2(1.5,1.5)
	elif boosting:
		Global.fuel -= 0.03
		velocity += -transform.y * acceleration * boost
		$Sprite/Fire.scale = Vector2(2,2)
		$Sprite/Fire.play("boosting")

	else:
		$Sprite/Fire.scale = Vector2(1.5,1.5)
		$Sprite/Fire.play("idle")
		$AudioStreamPlayer.stream_paused = true
		
		
	
	
	
	
	var rotation_dir = Input.get_axis("rotate_left", "rotate_right")
	rotate(rotation_dir * rotation_speed)
	
	move_and_slide(velocity)



func _on_boost_timer_timeout():
	boosting = false
