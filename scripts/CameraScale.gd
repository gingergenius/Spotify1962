extends Camera2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	var size = get_viewport().size
	var factor = max(size.x, size.y)
	factor/=720
	factor = 5/factor
	
	
	zoom = Vector2(factor, factor)
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
