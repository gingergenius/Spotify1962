extends RigidBody2D

export var WALK_SPEED = 1500
export var SNEAK_SPEED = 300
var velocity = Vector2()

var angle_vel = 6 * 3.141592
var target_angle = 0.0

onready var sprite = get_node("sprite")
onready var collisionShape = get_node("collisionShape")

func step_and_wrap_rotation (delta):
	var rotation = sprite.rotation
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

	sprite.rotation = rotation
	collisionShape.rotation = rotation


func _ready():
	sprite.rotation = rotation
	collisionShape.rotation = rotation
	target_angle = rotation
	rotation = 0

func _physics_process(delta):
	
	velocity.y += delta * 20
	if (Input.is_action_pressed("player_left")):
		velocity.x = -1
	elif (Input.is_action_pressed("player_right")):
		velocity.x =  1
	else:
		velocity.x = 0
	
	if (Input.is_action_pressed("player_up")):
		velocity.y = -1
	elif (Input.is_action_pressed("player_down")):
		velocity.y = 1
	else:
		velocity.y = 0

	set_linear_velocity(velocity.normalized() * (SNEAK_SPEED if Input.is_action_pressed("player_sneak") else WALK_SPEED))
	
	# Step rotation
	if velocity.length_squared() > 0.0001:
		target_angle = velocity.angle()
	step_and_wrap_rotation(delta)

