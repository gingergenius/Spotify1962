extends Panel

# class member variables go here, for example:
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	get_node("Button_play").connect("pressed",self,"load_first_level")
	get_node("Button_select").connect("pressed",self,"load_level_selection")
	get_node("Button_quit").connect("pressed",self,"quit")
	pass

func load_first_level():
	print("loading first level")
	get_tree().change_scene("res://scenes/levels/00_intro.tscn")
	pass
	
func load_level_selection():
	print("loading level selection screen")
	get_tree().change_scene("res://scenes/level_select_menu.tscn")
	pass

func quit():
	print("quitting")
	get_tree().quit()
	pass
