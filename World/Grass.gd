extends Node2D

const GrassEffect = preload("res://Effects/GrassEffect.tscn") # preloads and shares with instances


func create_grass_effect():
	var grass_effect = GrassEffect.instantiate() # create an instance of the GrassEffect scene
	get_parent().add_child(grass_effect)
	grass_effect.global_position = global_position
	queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.



func _on_hurtbox_area_entered(_area):
	create_grass_effect()
	queue_free()


