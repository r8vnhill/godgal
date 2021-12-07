extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var stars
var Star


# Called when the node enters the scene tree for the first time.
func _ready():
	stars = []
	Star = preload("../Escenas/Star.tscn")
	#var new_node = MyNode.instance()
	#if you want to change something in the node (for example the position here):
	#new_node.position = new_position
	#scene.add_child(new_node)
	# Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	if Input.is_action_pressed("ui_click"):
		var new_star = Star.instance()
		new_star.place = get_global_mouse_position()
		new_star.position = new_star.place
		stars.append(new_star)
		get_tree().get_current_scene().add_child(new_star)
		
