extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export var points = PoolVector2Array()
export var ParticleSeparation = 20.0
var transmission_ray_scene = load("res://TransmissionRay.tscn")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	var debugTransmission = get_node("debugTransmission")
	
	if debugTransmission and debugTransmission.visible:
		points = debugTransmission.points
		print ("Using debug transmission!")


func _process(delta):
	var num_rays = points.size() - 1
	var rays = get_node("Rays")
	
	if points.size() - 1 != rays.get_child_count():
		var ray_children = rays.get_children()
		
		for child in ray_children:
			print ("Removing child: ", child)
			rays.remove_child(child)
		
		for i in range(points.size() - 1):
			var origin = points[i]
			var length = (points[i + 1] - points[i]).length()
			var direction = (points[i + 1] - points[i]) / length
			
			var ray = transmission_ray_scene.instance()
			ray.position = origin
			ray.rotation = direction.angle()
			var emitter = ray.get_node("ParticleEmitter")
			var speed = emitter.process_material.initial_velocity
			emitter.lifetime = length / speed
			emitter.amount = length / ParticleSeparation
			print ("Instantiated ray: ", ray)
		
			get_node("Rays").call_deferred("add_child", ray)

#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
