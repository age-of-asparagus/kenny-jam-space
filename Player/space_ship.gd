extends KinematicBody2D

#var gliding_direction = 0
#var rotate_left = false
#var rotate_right = false
#var speed = 60
#var acceleration_speed = 1.03
#var decceleration_speed = 0.995
#var rotate_decceleration = 0.992
#var rotate_acceleration = 1.03
#var moving = false
#var rotate_speed_right = 0.6
#var rotate_speed_left = -0.6

var velocity := Vector2.ZERO  # stores the current speed and direction
export var acceleration = 0.5  # how much speed to add each frame
export var rotation_speed = 0.05
#var sprite_rotation_offset = Math.PI

func _physics_process(delta):
	
	if Input.is_action_pressed("ui_accept"):
		# Accelerating in direction of sprite
		# I used this recipe: https://kidscancode.org/godot_recipes/3.x/2d/topdown_movement/#option-2-rotate-and-move
		# then test +/- and x/y untill went in same direction as sprite =)
		velocity += -transform.y * acceleration
		$Sprite/Fire.visible = true
	else:
		$Sprite/Fire.visible = false
		
	
		
	
	# This gets both at same time and lets them cancel each other out
	var rotation_dir = Input.get_axis("ui_left", "ui_right")
	rotate(rotation_dir * rotation_speed)
	
	move_and_slide(velocity)
	
	print("Speed: ", int(velocity.length()))
	
		
#	if Input.is_action_pressed("ui_left"):
#		rotate_left = true
#
#	if Input.is_action_pressed("ui_right"):
#		rotate_right = true
	
#	global_rotation_degrees += rotate_speed_left + rotate_speed_right
	
#	if rotate_right:
#		if rotate_speed_right < 4:
#			rotate_speed_right *= rotate_acceleration
#	elif rotate_speed_right > 0.6:
#		rotate_speed_right *= rotate_decceleration
#
#	if rotate_left:
#		if rotate_speed_left > -4:
#			rotate_speed_left *= rotate_acceleration
#	elif rotate_speed_left < -0.6:
#		rotate_speed_left *= rotate_decceleration
	
	
	
#	if moving:
#		gliding_direction = global_rotation
#		move_and_slide(Vector2(speed - 60,0).rotated(rotation))
#		if speed < 480:
#			speed *= acceleration_speed
#	elif speed > 60:
#		move_and_slide(Vector2(speed - 60,0).rotated(gliding_direction))
#		speed *= decceleration_speed
	
#	moving = false
#	rotate_right = false
#	rotate_left = false
	
	
