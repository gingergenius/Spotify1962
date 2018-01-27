extends Node2D

# class member variables go here, for example:
var target
var line
var origin
var debug_line
var debug_collision_point
var space
var space_state
var transmission_objects = {}
var source_position
var goal_position

export var transmission_points = PoolVector2Array()

func updateLinePoints(line, points):
	for i in range (points.size()):
		if line.get_point_count() == i:
			line.add_point(points[i])
		else:
			line.set_point_position(i, points[i])
	while line.get_point_count() > points.size():
		line.remove_point(line.get_point_count() - 1)

func _ready():
	line = get_node("Line")
	debug_line = get_node("DebugLine")
	debug_collision_point = get_node("../Collision")
	space = get_world_2d().get_space()
	space_state = Physics2DServer.space_get_direct_state(space)
	
		# check whether we have debug target goal and source	
	if get_node("../Goal") and get_node("../Source"):
		source_position = get_node("../Source").position
		goal_position = get_node("../Goal").position
	
#recursively cast rays and append points array until given depth
func cast_ray(origin, target, points, cur_depth, max_depth):	
	if (cur_depth == max_depth):
		return points
	else:
		cur_depth +=1
		
		var result = space_state.intersect_ray(origin, target)
	
		if result.size() > 0:
			var collision_point = result.position
			var normal = result.normal
			
			# for the debugging scene of the Caster
			if debug_collision_point:
				debug_collision_point.position = collision_point

			# mark object as being reached by the transmission
			if not transmission_objects.has(result.collider):
				transmission_objects[result.collider] = true
			
			# add point if is sufficiently far away from the previous point
			var distance_to_previous = (points[points.size()-1] - collision_point).length_squared()
			if distance_to_previous > 0.01:
				points.push_back(collision_point)
				
			# compute the reflection
			var falling = collision_point - origin
			if falling.length_squared() < 0.01:
				points.push_back(target)
				return points
				
			falling = falling.normalized()
			var reflected = falling.reflect(normal)
			var new_target = collision_point + (-reflected) * 2000
			return cast_ray(collision_point + normal*0.001, new_target, points, cur_depth, max_depth)
		else:
			points.push_back(target)
			return points

func _physics_process(delta):
	# set up origin and target
	origin = self.position
	target = origin + Vector2(cos(self.rotation), sin(self.rotation)) * 2000

	if source_position and goal_position:
		origin = source_position
		target = goal_position

	var debug_points = PoolVector2Array()
	debug_points.push_back(Vector2(0.0, 0.0))
	debug_points.push_back(Vector2(100.0, 0.0))
	debug_points.push_back(Vector2(80.0, 20.0))
	debug_points.push_back(Vector2(100.0, 0.0))
	debug_points.push_back(Vector2(80.0, -20.0))
	updateLinePoints(debug_line, debug_points)

	# backup old transmissions
	var old_transmission_points = transmission_points
	var transmission_has_changed = false
	var old_transmission_objects = transmission_objects

	# prepare a clean raycast
	transmission_objects = {}
	var points = PoolVector2Array()
	points.push_back(origin)
	points = cast_ray(origin, target, points, 0, 5)
	
	if transmission_points.size() != points.size():
		transmission_has_changed = true
	
	transmission_points = PoolVector2Array()
	for i in range(points.size()):
		transmission_points.push_back(to_local(points[i]))
		
		if not transmission_has_changed:
			if transmission_points[i] != old_transmission_points[i]:
				transmission_has_changed = true

	updateLinePoints(line, transmission_points)	
	
	if transmission_has_changed:	
		var transmission = get_node("Transmission")
		transmission.points = transmission_points
		transmission.reset_transmission = true

		# check which objects are no more in the transmission
		var old_transmission_objects_list = old_transmission_objects.values()
		for o in old_transmission_objects_list:
			if not transmission_objects.has(o):
				# object is no more touched by the transmission
				pass
		
		var new_transmission_objects_list = transmission_objects.values()
		for o in new_transmission_objects_list:
			if not old_transmission_objects.has(o):
				# object is being touched by the transmission
				pass
		
