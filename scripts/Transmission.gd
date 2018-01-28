extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export var points = PoolVector2Array()
export var reset_transmission = false
export var ParticleSeparation = 20.0
var transmission_ray_scene = load("res://objects/TransmissionRay.tscn")
var max_length = 100000

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
	
	if reset_transmission:
		var ray_children = rays.get_children()
		
		for child in ray_children:
			rays.remove_child(child)
		
		var total_ray_length = 0
		
		for i in range(points.size() - 1):
			var origin = points[i]
			var length = (points[i + 1] - points[i]).length()
			var direction = (points[i + 1] - points[i]) / length
			
			total_ray_length = total_ray_length + length
			if total_ray_length > max_length:
				break
			
			var opacity = (max_length - total_ray_length) / max_length
			
			# Instantiate the ray and also assign settings
			var ray = transmission_ray_scene.instance()
			ray.position = origin
			ray.rotation = direction.angle()
			var emitter = ray.get_node("ParticleEmitter")
			var speed = emitter.process_material.initial_velocity
			emitter.lifetime = length / emitter.scale.x / speed
			emitter.amount = length / emitter.scale.x / ParticleSeparation
			emitter.modulate = Color(1, 1, 1, opacity)
		
			get_node("Rays").call_deferred("add_child", ray)
		
		reset_transmission = false

#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
