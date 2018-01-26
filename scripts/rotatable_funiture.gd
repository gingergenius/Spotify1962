extends Node2D

export(NodePath) var player
export var MAX_PULL_DISTANCE = 200

var pulling = false
var lastRotation = 0

func _ready():
	pass

func dist(var a, var b):
	return sqrt( (a.x-b.x)*(a.x-b.x) + (a.y-b.y)*(a.y-b.y))

func _process(delta):
	var distance = get_node(player).position - position
	if (distance.length() < MAX_PULL_DISTANCE && Input.is_action_pressed("player_pull")):
		if !pulling:
			lastRotation = atan2(distance.x, -distance.y)
			pulling = true
		var currentRotation = atan2(distance.x, -distance.y)

		# pull this furniture		
		rotation += currentRotation - lastRotation
		lastRotation = currentRotation
	else:
		pulling = false
