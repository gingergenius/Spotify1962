extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var points = PoolVector2Array()

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	
	var direction = Vector2(1.0, 0.0)

	points.push_back(self.position)
	points.push_back(self.position + direction * 100)	
	

	pass

func calcTransmissionPoints(max_points):
	var ray_position = self.position
	var ray_direction = Vector2(1.0, 0.0)

	var raycast = RayCast2D()
	
	self.draw_line(points[0], points[1])

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
