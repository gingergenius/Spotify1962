extends RigidBody2D

var startPosition

func _ready():
	startPosition = position
	pass

func _physics_process(delta):
	# fixed position
	#position = startPosition
	pass