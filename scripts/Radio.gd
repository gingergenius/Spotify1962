extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var isTransmissionSink = true

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
	
func onTransmissionStart():
	print ("Transmission starting")
	
func onTransmissionStop():
	print ("Transmission stopping")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
