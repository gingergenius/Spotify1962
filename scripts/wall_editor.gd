tool
extends StaticBody2D

export(NodePath) var _collider = "collisionShape"
onready var collider = get_node(_collider)
export(NodePath) var _sprite = "collisionShape/sprite"
onready var sprite = get_node(_sprite)

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	print(collider.position)
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	if sprite != null && collider != null:
		sprite.region_rect.size = collider.shape.extents * 2
		
		# scale shall not be changed!
		if (collider.scale != Vector2(1,1) || sprite.scale != Vector2(1,1) || scale != Vector2(1,1)):
			print("ERROR: PLEASE DON'T CHANGE THE SCALE!")
			collider.scale = Vector2(1,1)
			sprite.scale = Vector2(1,1)
			scale = Vector2(1,1)
			# don't move if we are currently scaling
			collider.position = Vector2(0,0)
			sprite.position = Vector2(0,0)
		
		# position shall not be changed
		position += collider.position
		collider.position = Vector2(0,0)
		position += sprite.position
		sprite.position = Vector2(0,0)
	