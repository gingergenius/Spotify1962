extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var ray_cast 
var goal
var line
var source
var debug_line
var collision
var space
var space_state

func updateLinePoints(line, points):
	print (points.size())
	
	for i in range (points.size()):
		if line.get_point_count() == i:
			line.add_point(points[i])
		else:
			line.set_point_position(i, points[i])
	while line.get_point_count() > points.size():
		line.remove_point(line.get_point_count() - 1)

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	ray_cast = get_node("RayCast")
	goal = get_node("../Goal")
	source = get_node("../Source")
	line = get_node("Line")
	debug_line = get_node("DebugLine")
	collision = get_node("../Collision")
	space = get_world_2d().get_space()
	space_state = Physics2DServer.space_get_direct_state(space)
	

#recursively cast rays and append points array until given depth
func cast_ray(source, goal, points, cur_depth, max_depth):	
	if (cur_depth == max_depth):
		return points
	else:
		cur_depth +=1
		#ray_cast.position = source
		#ray_cast.cast_to = goal - source
		#ray_cast.force_raycast_update()
		
		var result = space_state.intersect_ray(source, goal)
	
		if result.size() > 0:
			var collision_point = result.position
			var distance_to_previous = (points[points.size()-1] - collision_point).length_squared()
			
			if (distance_to_previous > 0.01):
				points.push_back(collision_point)
			collision.position = collision_point
			var normal = result.normal
			var falling = collision_point - source
			
			if falling.length_squared() < 0.01:
				points.push_back(goal)
				return points
				
			falling = falling.normalized()
			var reflected = falling.reflect(normal)
			var new_goal = collision_point + (-reflected) * 2000
			return cast_ray(collision_point, new_goal, points, cur_depth, max_depth)
		else:
			points.push_back(goal)
			return points

func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
	pass

func _physics_process(delta):
	
	var points = PoolVector2Array()
	points.push_back(to_local(source.position))

	var debug_points = PoolVector2Array()
	debug_points.push_back(to_local(source.position))
	debug_points.push_back(to_local(goal.position))
	updateLinePoints(debug_line, debug_points)

	var final_points = cast_ray(to_local(source.position), to_local(goal.position), points, 0, 7)
	updateLinePoints(line, final_points)
