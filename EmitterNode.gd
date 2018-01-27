extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var transmissionPoints = PoolVector2Array()
var direction = Vector2(1.0, 0.0)

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	
	var direction = Vector2(1.0, 0.0)

	transmissionPoints.push_back(to_local(self.position))
	transmissionPoints.push_back(to_local(self.position + Vector2(20, 10) * 10))	
	transmissionPoints.push_back(to_local(self.position + Vector2(-20, 10) * 10))	
	transmissionPoints.push_back(to_local(self.position + Vector2(-0, -10) * 10))	

	pass

func calcTransmissionPoints(max_points):
	var ray_position = self.position
	var ray_direction = Vector2(1.0, 0.0)

	var raycast = RayCast2D()

func updateLinePoints(line, points):
	print (points.size())
	
	for i in range (points.size()):
		print("processing point ", i)
		if line.get_point_count() <= i:
			line.add_point(points[i])
		else:
			line.set_point_position(i, points[i])

func _process(delta):
	var line = get_node("Line2D")
	
#	while line.get_point_count() > 0:
#		line.remove_point(line.get_point_count() - 1)

#	line.points = points
		
	#line.add_point(self.position)
	#line.add_point(self.position + Vector2(1.0, 1.0) * 100)
	
	var direction_line = get_node("DirectionLine")
	print ("I have ", direction_line.get_point_count(), " points")	
	updateLinePoints(direction_line, [
		(Vector2(0.0, 0.0)), 
		(Vector2(50.0, 0.0)), 
		(Vector2(30.0, 15.0)),
		(Vector2(50.0, 0.0)), 
		(Vector2(30.0, -15.0)), 
		])
	
#	var transmission_line = get_node("TransmissionPath")
#	updateLinePoints(transmission_line, transmissionPoints)
	
#	line.set_point_position(1, points[1])
#	line.set_point_position(0, Vector2(0.0, 0.0))
	
	#pass
	
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
