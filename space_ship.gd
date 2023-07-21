extends KinematicBody2D

var gliding_direction = 0
var rotate_left = false
var rotate_right = false
var speed = 60
var acceleration_speed = 1.03
var decceleration_speed = 0.995
var rotate_decceleration = 0.992
var rotate_acceleration = 1.03
var moving = false
var rotate_speed_right = 0.6
var rotate_speed_left = -0.6

func _physics_process(delta):
	
	print(gliding_direction)
	
	if Input.is_action_pressed("move_forward"):
		moving = true
	if Input.is_action_pressed("turn_left"):
		rotate_left = true
	
	if Input.is_action_pressed("turn_right"):
		rotate_right = true
	
	global_rotation_degrees += rotate_speed_left + rotate_speed_right
	
	if rotate_right:
		if rotate_speed_right < 4:
			rotate_speed_right *= rotate_acceleration
	elif rotate_speed_right > 0.6:
		rotate_speed_right *= rotate_decceleration
		
	if rotate_left:
		if rotate_speed_left > -4:
			rotate_speed_left *= rotate_acceleration
	elif rotate_speed_left < -0.6:
		rotate_speed_left *= rotate_decceleration
	
	
	
	if moving:
		gliding_direction = global_rotation
		move_and_slide(Vector2(speed - 60,0).rotated(rotation))
		if speed < 480:
			speed *= acceleration_speed
	elif speed > 60:
		move_and_slide(Vector2(speed - 60,0).rotated(gliding_direction))
		speed *= decceleration_speed
	
	moving = false
	rotate_right = false
	rotate_left = false
	
	
