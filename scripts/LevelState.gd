extends Node2D

export var num_transmission_sinks = 1
var num_active_transmissions = 0

func _ready():
	pass

func _process(delta):
	pass

func _on_Radio_transmission_started():
	num_active_transmissions = num_active_transmissions + 1
	print ("Level State: transmission started. active count: ", num_active_transmissions)

	if num_active_transmissions == num_transmission_sinks:
		get_tree().change_scene("res://scenes/win_menu.tscn")

	pass # replace with function body


func _on_Radio_transmission_stopped():
	num_active_transmissions = num_active_transmissions - 1
	print ("Level State: transmission stopped. active count: ", num_active_transmissions)

	pass # replace with function body
