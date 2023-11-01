extends Area2D

const HitEffect = preload("res://Effects/HitEffect.tscn")

signal invicibility_started
signal invicibility_ended
@onready var timer = $Timer

var invincible = false: 
	get: # get the current value of invincivbility
		return invincible
	set(value): 
		invincible = value
		if invincible == true:
			emit_signal("invicibility_started")
		else:
			emit_signal("invicibility_ended")

func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)
	

func create_hit_effect():
	var effect = HitEffect.instantiate()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position - Vector2(0,-4)


func _on_timer_timeout():
	self.invincible = false


func _on_invicibility_started():
	set_deferred ("monitoring", false)


func _on_invicibility_ended():
	monitoring = true
