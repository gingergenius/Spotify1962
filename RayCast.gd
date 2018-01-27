extends RayCast2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var ray_cast 
var goal
var line
var points

func updateLinePoints(line, points):
	print (points.size())
	
	for i in range (points.size()):
		print("processing point ", i)
		if line.get_point_count() == i:
			line.add_point(points[i])
		else:
			line.set_point_position(i, points[i])
	while line.get_point_count() > points.size():
		line.remove_point(line.get_point_count() - 1)

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	ray_cast = get_node(".")
	goal = get_node("../Goal")
	line = get_node("Line")

func cast_ray(ray_cast, goal, points, depth):
	
	pass

func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.

	points = PoolVector2Array()
	points.push_back(to_local(ray_cast.position))

	ray_cast.cast_to = to_local(goal.position)
	var source = ray_cast.position
	var end = goal.position
	
	if (ray_cast.is_colliding()):
		end = ray_cast.get_collision_point()

	points.push_back(to_local(end))
	
	if (ray_cast.is_colliding()):
		var normal = ray_cast.get_collision_normal().normalized()
		var falling = to_local(get_collision_point())
		falling = falling.normalized()
		var reflected = falling.reflect(normal)
		reflected = - reflected * 2000
		points.push_back(to_local(end)+reflected)
	
	updateLinePoints(line, points)
