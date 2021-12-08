extends Node2D


# Member variables
var place 


# Called when the node enters the scene tree for the first time.
func _ready():
	place = Vector2(0,0)

# Return the place of the star 
func get_place() -> Vector2:
	return place
	
# Sets the place in the star and in its position
func set_place(new_place: Vector2):
	place = new_place
	position = place
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# To see if a star is in the same position of other star
func equals(star):
	if star.get_class() == "Star":
		if star.get_place() == place:
			return true
	return false
