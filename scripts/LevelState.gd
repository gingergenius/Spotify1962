extends Node2D

const radio_class = preload("Radio.gd")
const player_class = preload("player.gd")
const DIST_MAX = 1000000

export var num_transmission_sinks = 1
export var music_near_radius = 200
export var music_far_radius = 800

var num_active_transmissions = 0
var transmission_sinks
var radios = []
var player
var level_music
var completed 
var radio_music_factor

func _ready():
	radios = []
	level_music = get_node("LevelMusic")
	completed = false
	radio_music_factor = 0.0
	find_player_and_all_radios()
	pass

func find_player_and_all_radios():
	for c in get_node("..").get_children():
		if c is radio_class:
			radios.push_back(c)
		elif c is player_class:
			player = c

func _process(delta):
	completed = num_active_transmissions == num_transmission_sinks
	
	if not completed:
		checkTransmissionPointsWithRadios([])
	else:
		setRadioMusicFactor(1.0)
	pass

func _on_Radio_transmission_started():

	num_active_transmissions = num_active_transmissions + 1
	print ("Level State: transmission started. active count: ", num_active_transmissions)

	completed = num_active_transmissions == num_transmission_sinks
	if completed:
		win()

	pass # replace with function body

func onTransmissionStarted(points):
	num_active_transmissions = num_active_transmissions + 1
	print ("Level State: transmission started. active count: ", num_active_transmissions)

	completed = num_active_transmissions == num_transmission_sinks
	if completed:
		win()

	pass # replace with function body

func _on_Radio_transmission_stopped():
	num_active_transmissions = num_active_transmissions - 1
	completed = num_active_transmissions == num_transmission_sinks
	print ("Level State: transmission stopped. active count: ", num_active_transmissions)

	pass # replace with function body

func onTransmissionChanged(points):
	print("transmission changed!")
	checkTransmissionPointsWithRadios(points)


func calcDistanceLineSegmentPoint(l1, l2, p):
	var r = l2 - l1
	if r.length_squared() < 0.001:
		return (l2 - p).length()
	
	var rn = r.normalized()
	var sn = (p - l1).normalized()
	
	return (l1 + sn.dot(rn) * r - p).length()

func setRadioMusicFactor(music_factor):
	radio_music_factor = music_factor
	
	for r in radios:
		var noise = r.get_node("Noise")
		noise.volume_db = -40 * music_factor
		level_music.volume_db = -20 * (1.0 - music_factor) - 10

func checkTransmissionPointsWithRadios(points):
	if points.size() < 2:
		return
	
	var mean_distance = 0
	var summed_distance = 0
	
	for r in radios:
		var radio_position = r.position
		var min_segment_dist = DIST_MAX
		for i in range (points.size() - 1):
			var p1 = points[i]
			var p2 = points[i+1]
			min_segment_dist = min(min_segment_dist, calcDistanceLineSegmentPoint(p1, p2, radio_position))
			
		assert (min_segment_dist != DIST_MAX)
#		print ("Radio ", r.name, " min distance: ", min_segment_dist)
		summed_distance = summed_distance + min_segment_dist

	mean_distance = summed_distance / radios.size()
					
#	print ("mean distance: ", mean_distance)
#	print ("distance to player: ", (r.position - player.position).length())
		
	mean_distance = min(music_far_radius, mean_distance)
	mean_distance = max(music_near_radius, mean_distance)
	
	var music_factor = (music_far_radius - mean_distance) / (music_far_radius - music_near_radius)
	print (music_factor)
	
	setRadioMusicFactor(music_factor)
	
#	for p in points:
#		for r in radios:
#			var dist = (p - r).length_squared()
			
func win():
	var scene = load("res://scenes/win_menu.tscn")
	var node = scene.instance()
	add_child(node)
