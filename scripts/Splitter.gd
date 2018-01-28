extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var casterA
var casterB

var isTransmissionSink = true

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	casterA = get_node("CasterA")
	casterB = get_node("CasterB")
	pass

func onTransmissionStart(remaining_iter):
	if remaining_iter > 0:
		print ("Splitter enabled! Iter: ", remaining_iter)
		casterA.max_num_rays = remaining_iter
		casterA.enable()
		casterB.max_num_rays = remaining_iter
		casterB.enable()
	else:
		print ("Splitter not enabling: no remaining iterations")
	pass


func onTransmissionStop():
	print ("Splitter disabled!")
	
	casterA.disable()
	casterB.disable()

	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
