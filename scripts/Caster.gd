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

signal transmission_changed

export var transmission_points = PoolVector2Array()
export var max_num_rays = 30
export var max_transmission_length = 1000
export var ray_length = 10000.0
export var is_enabled = true

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
	if has_node("../Collision"):
		debug_collision_point = get_node("../Collision")
	space = get_world_2d().get_space()
	space_state = Physics2DServer.space_get_direct_state(space)
	
		# check whether we have debug target goal and source	
	if has_node("../Goal") and has_node("../Source"):
		source_position = get_node("../Source").position
		goal_position = get_node("../Goal").position
		
	if has_node("/root/game/LevelState"):
		var level_state = get_tree().get_root().get_node("/root/game/LevelState")
		connect ("transmission_changed", level_state, "onTransmissionChanged")
	else:
		print ("did not find levelstate")

	
#recursively cast rays and append points array until given depth
func cast_ray(origin, target, points, cur_depth, max_depth):	
	if (cur_depth == max_depth):
		return points
	else:
		cur_depth +=1
		
		var result = space_state.intersect_ray(origin, target, Array(), 1)
	
		if result.size() > 0:
			var collision_point = result.position
			var normal = result.normal
			var collider = result.collider
			
			# for the debugging scene of the Caster
			if debug_collision_point:
				debug_collision_point.position = collision_point

			# mark object as being reached by the transmission
			if not transmission_objects.has(result.collider):
				transmission_objects[result.collider] = cur_depth

			# check whether we are at the end of a transmission
			var is_object_transmission_sink = "isTransmissionSink" in collider and collider.isTransmissionSink
			
			# add point if is sufficiently far away from the previous point
			var distance_to_previous = (points[points.size()-1] - collision_point).length_squared()
			if distance_to_previous > 0.01:
				points.push_back(collision_point)
				if is_object_transmission_sink:
					return points
				
			# compute the reflection
			var falling = collision_point - origin
			
			if falling.length_squared() < 0.01 :
				points.push_back(target)
				return points
				
			falling = falling.normalized()
			var reflected = falling.reflect(normal)
			var new_target = collision_point + (-reflected) * ray_length
			return cast_ray(collision_point + normal*0.001, new_target, points, cur_depth, max_depth)
		else:
			points.push_back(target)
			return points

func disable():
	is_enabled = false

	# Reset the transmission line
	transmission_points = PoolVector2Array()
	updateLinePoints(line, transmission_points)	
	
	# Reset the transmission itself
	var transmission = get_node("Transmission")
	transmission.points = transmission_points
	transmission.reset_transmission = true

func enable():
	is_enabled = true

func _physics_process(delta):
	if not is_enabled:
		return
	
	# set up origin and target
	origin = self.position
	target = origin + Vector2(cos(self.rotation), sin(self.rotation)) * ray_length

	if source_position and goal_position:
		origin = source_position
		target = goal_position
		
	var debug_points = PoolVector2Array()
	var debug_line_scale = 3

	# transform origin and target if we are relative to a node with
	# a position property
	var parent = get_parent()
	if parent.get("position"):
		origin = to_global(origin)
		target = to_global(target)
	
		debug_points.push_back(Vector2(0.0, 0.0).rotated(self.rotation) * debug_line_scale)
		debug_points.push_back(Vector2(100.0, 0.0).rotated(self.rotation) * debug_line_scale)
		debug_points.push_back(Vector2(80.0, 20.0).rotated(self.rotation) * debug_line_scale)
		debug_points.push_back(Vector2(100.0, 0.0).rotated(self.rotation) * debug_line_scale)
		debug_points.push_back(Vector2(80.0, -20.0).rotated(self.rotation) * debug_line_scale)
	else:
		debug_points.push_back((Vector2(0.0, 0.0) * debug_line_scale))
		debug_points.push_back((Vector2(100.0, 0.0) * debug_line_scale))
		debug_points.push_back((Vector2(80.0, 20.0) * debug_line_scale))
		debug_points.push_back((Vector2(100.0, 0.0) * debug_line_scale))
		debug_points.push_back((Vector2(80.0, -20.0) * debug_line_scale))

		
	updateLinePoints(debug_line, debug_points)

	# backup old transmissions
	var old_transmission_points = transmission_points
	var transmission_has_changed = false
	var old_transmission_objects = transmission_objects

	# prepare a clean raycast
	transmission_objects = {}
	var points = PoolVector2Array()
	points.push_back(origin)
	points = cast_ray(origin, target, points, 0, max_num_rays)
	
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
		emit_signal("transmission_changed", points)
		
		var transmission = get_node("Transmission")
		transmission.points = transmission_points
		transmission.max_length = max_transmission_length
		transmission.reset_transmission = true

		# check which objects are no more in the transmission
		var old_transmission_objects_list = old_transmission_objects.keys()
		for o in old_transmission_objects_list:
			if not transmission_objects.has(o):
				if o.has_method("onTransmissionStop"):
					o.onTransmissionStop()
		
		var new_transmission_objects_list = transmission_objects.keys()
		for o in new_transmission_objects_list:
			if not old_transmission_objects.has(o):
				# object is being touched by the transmission
				if o.has_method("onTransmissionStart"):
					o.onTransmissionStart(max_num_rays - transmission_objects[o])
		
		transmission_has_changed = false
		
