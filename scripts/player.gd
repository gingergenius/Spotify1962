extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
const WALK_SPEED = 200
var velocity = Vector2()


func _ready():
	pass

func _physics_process(delta):
	
	velocity.y += delta * 20
	print("test")
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

	move_and_slide(velocity)
	

