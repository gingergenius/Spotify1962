extends RayCast2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var ray_cast 
var goal
var line

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	ray_cast = get_node(".")
	goal = get_node("../Goal")
	line = get_node("Line")
	line.set_point_position(0,to_local(ray_cast.position))

func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.

	for i in range(1, line.points.size()-1):
		line.remove_point(i)

	ray_cast.cast_to = to_local(goal.position)
	var source = ray_cast.position
	var end = goal.position
	
	if (ray_cast.is_colliding()):
		end = ray_cast.get_collision_point()

	line.add_point(to_local(end))
	
	if (ray_cast.is_colliding()):		
		var normal = ray_cast.get_collision_normal()
		var reflected = normal.reflect(source-end)
		line.add_point(to_local(reflected))
