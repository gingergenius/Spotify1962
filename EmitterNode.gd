extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export var transmissionPoints = PoolVector2Array()
export var transmissionFrom = Vector2(0.0, 0.0)
export var transmissionTo = Vector2(100.0, 0.0)
var direction = Vector2(1.0, 0.0)

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	
	var direction = Vector2(1.0, 0.0)

	transmissionPoints.push_back(transmissionFrom)
	transmissionPoints.push_back(transmissionTo)	

	pass

func updateLinePoints(line, points):
	print (points.size())
	
	for i in range (points.size()):
		if line.get_point_count() <= i:
			line.add_point(points[i])
		else:
			line.set_point_position(i, points[i])

func updateParticleEmitter():
	
	pass

func _process(delta):
	var line = get_node("Line2D")
	
	var direction_line = get_node("DirectionLine")

	updateLinePoints(direction_line, [
		(Vector2(0.0, 0.0)), 
		(Vector2(50.0, 0.0)), 
		(Vector2(30.0, 15.0)),
		(Vector2(50.0, 0.0)), 
		(Vector2(30.0, -15.0)), 
		])
	
	#updateLinePoints(get_node("TransmissionPath"), transmissionPoints)
	
	updateParticleEmitter()
	
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
