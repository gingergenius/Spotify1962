extends Node

var current_scene = null
var current_stage = 0
var level_names = ["Level 0 - WASDhat signal?",
				 	"Level 1 - Spin it like a spacebar",
					"Level 2 - Push & Pull like a git pro",
					"Level 3 - Cut my radio into pieces",
					"Level xx - Vacuum the rug"]
var level_filenames = ["00_intro", "01_rotate", "02_pull", "03_splitter", "11_advanced"]

func _ready():
        var root = get_tree().get_root()
        current_scene = root.get_child( root.get_child_count() -1 )

func goto_next_stage():
	current_stage += 1
    # This function will usually be called from a signal callback,
    # or some other function from the running scene.
    # Deleting the current scene at this point might be
    # a bad idea, because it may be inside of a callback or function of it.
    # The worst case will be a crash or unexpected behavior.

    # The way around this is deferring the load to a later time, when
    # it is ensured that no code from the current scene is running:
	call_deferred("_deferred_goto_scene")


func _deferred_goto_scene():
	
	# Immediately free the current scene,
	# there is no risk here.
	#current_scene.free()
	
	# Load new scene
	var filename = level_filenames[current_stage]
	print("loading level " + filename)
	var path = "res://scenes/levels/" + filename + ".tscn"
	
	get_tree().change_scene(path)
	
	#var s = ResourceLoader.load(path)
	
	# Instance the new scene
	#current_scene = s.instance()
	
	# Add it to the active scene, as child of root
	#get_tree().get_root().add_child(current_scene)
	
	# optional, to make it compatible with the SceneTree.change_scene() API
	#get_tree().set_current_scene( current_scene )
