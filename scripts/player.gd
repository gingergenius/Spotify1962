extends RigidBody2D

const WALK_SPEED = 200
var velocity = Vector2()

var angle_vel = 6 * 3.141592
var target_angle = 0.0

onready var sprite = get_node("sprite")


func step_and_wrap_rotation (delta):
	var rotation = sprite.rotation
	var rot_delta = target_angle - rotation
	print("rotation:", rotation)
	print(rot_delta)
	
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

	sprite.rotation = rotation


func _ready():
	pass

func _physics_process(delta):
	
	velocity.y += delta * 20
	if (Input.is_action_pressed("player_left")):
		velocity.x = -WALK_SPEED
	elif (Input.is_action_pressed("player_right")):
		velocity.x =  WALK_SPEED
	else:
		velocity.x = 0
	
	if (Input.is_action_pressed("player_up")):
		velocity.y = -WALK_SPEED
	elif (Input.is_action_pressed("player_down")):
		velocity.y = WALK_SPEED
	else:
		velocity.y = 0

	set_linear_velocity(velocity)
	
	# Step rotation
	if velocity.length_squared() > 0.0001:
		target_angle = velocity.angle()
	step_and_wrap_rotation(delta)

