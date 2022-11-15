extends KinematicBody


func _ready():
	pass 
	
func die():
	queue_free()
	get_tree().change_scene("res://Game.tscn")
	Global.level += 1
