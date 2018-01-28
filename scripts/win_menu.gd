extends CenterContainer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	get_node("MarginContainer/HBoxContainer/VBoxContainer/popup/Button_continue").connect("pressed",self,"continue")
	pass

func continue():
	get_node("/root/global").goto_next_stage()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
