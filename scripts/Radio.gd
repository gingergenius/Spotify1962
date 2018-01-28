extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

signal transmission_started
signal transmission_stopped

var isTransmissionSink = true

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	
			
	if get_node("../LevelState"):
		var level_state = get_node("../LevelState")
		connect ("transmission_started", level_state, "onTransmissionStarted")
		connect ("transmission_stopped", level_state, "onTransmissionStopped")
	
	pass
	
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
#
func onTransmissionStart(iter):
	print ("Transmission starting")
	emit_signal ("transmission_started", [])
        
func onTransmissionStop():
	print ("Transmission stopping")
	emit_signal ("transmission_stopped")

