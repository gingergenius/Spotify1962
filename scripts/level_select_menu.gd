extends Panel

# class member variables go here, for example:
var current_stage = 0
var amount_stages = 3
var level_names = ["Intro", "Level 1 - get a move on", "Level 2 - vacuum the rug"]
var level_filenames = ["00_intro", "01_medium", "02_advanced"]

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	get_node("navigation/Button_right").connect("pressed",self,"next_stage")
	get_node("navigation/Button_left").connect("pressed",self,"prev_stage")
	get_node("Button_play").connect("pressed",self,"play_stage")
	pass

func next_stage():
	current_stage = (current_stage + 1) % amount_stages
	update_stage()
	pass

func prev_stage():
	current_stage = (current_stage - 1 + amount_stages) % amount_stages
	update_stage()
	pass

func update_stage():
	get_node("navigation/stage_name").text = level_names[current_stage]
	var texture = load("res://images/level_preview/" + str(current_stage) + ".png")
	get_node("level_preview/image").set_texture(texture)
	pass

func play_stage():
	var filename = level_filenames[current_stage]
	print("loading level " + filename)
	get_tree().change_scene("res://scenes/levels/" + filename + ".tscn")
	pass


#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
