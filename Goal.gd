extends Position2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var Goal

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	Goal = get_node(".")
	set_process_input(true)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _input(ev):
   # Mouse in viewport coordinates
	if ev is InputEventMouseButton:
		Goal.position = ev.position
