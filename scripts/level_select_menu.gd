extends Panel

# class member variables go here, for example:
var current_stage = 0
var amount_stages = 3

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
	var global = get_node("/root/global")
	get_node("navigation/stage_name").text = global.level_names[current_stage]
	var texture = load("res://images/level_preview/" + global.level_filenames[current_stage] + ".png")
	get_node("level_preview/image").set_texture(texture)
	pass

func play_stage():
	var global = get_node("/root/global")
	global.current_stage = current_stage-1
	global.goto_next_stage()
	pass


#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
