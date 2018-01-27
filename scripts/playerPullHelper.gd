extends Node2D

var isPulling = false
var pullingNode = null
export var PULLING_DISTANCE = 500
export var PULLING_SPEED = 1200
export var SNEAK_PULLING_SPEED = 300
var offset = null
onready var player = get_node("..")

func _ready():
	pass

func get_nearest_furniture():
	var furnitures = get_tree().get_nodes_in_group("Furniture")
	var nearest = null
	var distance = PULLING_DISTANCE
	for furniture in furnitures:
		var dist = furniture.global_position.distance_to(global_position) 
		if dist < distance:
			distance = dist
			nearest = furniture
	return nearest

func _physics_process(delta):
	if Input.is_action_pressed("player_pull"):
		if !isPulling:
			# find nearest node that is within radius
			pullingNode = get_nearest_furniture()
			if pullingNode != null:
				isPulling = true
				offset = pullingNode.global_position - global_position
		if pullingNode != null:
			var a = player.get_linear_velocity()
			if (a.length() > 0):
				var b = pullingNode.global_position - global_position
				
				var vel = a.length() * a.dot(b) * b
				vel = vel.normalized() * (SNEAK_PULLING_SPEED if Input.is_action_pressed("player_sneak") else PULLING_SPEED)
				
				if b.dot(vel) < 0:
					pullingNode.set_linear_velocity(vel)
					player.set_linear_velocity(player.get_linear_velocity() * 0.7) # slower while dragging
				else:
					pullingNode.set_linear_velocity(Vector2(0,0))			
#				var vel = (a.dot(b) / (a.length() * b.length() )) * (b/b.length())
			if pullingNode.global_position.distance_to(global_position) > PULLING_DISTANCE:
				isPulling = false
	else:
		if isPulling:
			isPulling = false
			pullingNode.set_linear_velocity(Vector2(0,0))
			