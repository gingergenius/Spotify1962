extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var speed = 100
var angle = 0.0
var angle_vel = 3 * 3.141592
var target_angle = 0.0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func step_and_wrap_rotation (delta):
	var rotation = self.rotation
	var rot_delta = target_angle - rotation
	
	if rot_delta < -PI:
		target_angle = target_angle + 2 * PI
		rot_delta = rot_delta + 2 * PI
	elif rot_delta > PI:
		target_angle = target_angle - 2 * PI
		rot_delta = rot_delta - 2 * PI

	var rot_direction = sign(rot_delta)
	var angle_min = rotation
	var angle_max = target_angle
	if rot_direction < 0.0:
		angle_min = target_angle
		angle_max = rotation
	
	rotation = max(angle_min,
		min(angle_max, rotation + rot_direction * angle_vel * delta)
	)
	
	if rotation > 2 * PI:
		rotation -= 2 * PI
	if rotation < -2 * PI:
		rotation += 2 * PI

	self.rotation = rotation

func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
	var direction = Vector2()
	if Input.is_action_pressed("move_left"):
		direction.x = direction.x - 1.0
	if Input.is_action_pressed("move_right"):
		direction.x = direction.x + 1.0
	if Input.is_action_pressed("move_up"):
		direction.y = direction.y - 1.0
	if Input.is_action_pressed("move_down"):
		direction.y = direction.y + 1.0

	# Integrate position
	var position = self.position
	
	var velocity = direction * speed
	position = position + delta * velocity

	self.position = position
	
	if velocity.length_squared() > 0.0001:
		target_angle = velocity.angle()
	
	# Step rotation
	step_and_wrap_rotation(delta)



