extends Control

#MOVE HEALTH LOGIC TO STATS NODE
#
#
#
@onready var HeartUIFull = $HeartUIFull
@onready var HeartUIEmpty = $HeartUIEmpty
var stats = PlayerStats

var hearts = 4: set = set_hearts, get = get_hearts

func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	if HeartUIFull != null:
		HeartUIFull.set_size(Vector2(hearts * 15, 11)) # Each full heart is 15 pixels wide by 11 tall


func get_hearts():
	return hearts


var max_hearts = 4: set = set_max_hearts, get = get_max_hearts
	
func set_max_hearts(value):
	max_hearts = max(value, 1)
	if HeartUIEmpty != null:
		HeartUIEmpty.set_size(Vector2(hearts * 15, 11)) 
	
func get_max_hearts():
	return max_hearts

func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	self.stats.connect("health_changed", set_hearts)
	self.stats.connect("max_health_changed", set_max_hearts)
	
