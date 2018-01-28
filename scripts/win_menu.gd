extends CanvasLayer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	var cont = get_node("popup/Button_continue")
	cont.grab_focus()
	cont.connect("pressed",self,"continue")
	var menu = get_node("popup/Button_menu")
	menu.connect("pressed",self,"to_menu")
	pass 

func continue():
	get_node("/root/global").goto_next_stage()

func to_menu():
	get_tree().change_scene("res://scenes/main_menu.tscn")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
