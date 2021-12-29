extends Node2D


# Member variables
var stars
var Star
var Poligono = []

onready var polygon = $Polygon2D

# Called when the node enters the scene tree for the first time.
func _ready():
    stars = []
    Star = preload("../Escenas/Star.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# warning-ignore:unused_argument
# Interact with input
func _input(event):
    if Input.is_action_pressed("ui_click"):
        var new_star = createStar()
        stars.append(new_star)
        get_tree().get_current_scene().add_child(new_star)
        update()
    if Input.is_action_pressed("ui_der_click"):
        var new_star = createStar()
        for star in stars:
            if star == new_star:
                stars.remove(star)
                get_tree().get_current_scene().remove_child(star)
        update()

# Creates a new instance of Star in the mouse position
func createStar():
    var new_star = Star.instance()
    new_star.set_place(get_global_mouse_position())
    return new_star		

# return the positions of the stars
func get_positions():
    var positions = []
    for star in stars:
        positions.append(star.position)
    return positions

# Se llama cada vez que se hace update()
# No se porque no dibuja al poligono :C
func _draw():
    var colors = PoolColorArray([Color(1,1,1, 0.5)])
    if stars.size() >=3:
        Poligono = get_positions()
        polygon.create_polygon(Poligono,colors)
