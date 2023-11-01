extends CharacterBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")
@onready var stats = $Stats
@onready var playerDetectionZone = $PlayerDetectionZone
@onready var hurtbox = $Hurtbox


@export var MAX_SPEED = 50
@export var ACCELERATION = 400
@export var FRICTION = 500

#states of the bat
enum {
	IDLE,
	WANDER,
	CHASE
}

var state = IDLE

# knockback variables
var knockback = Vector2.ZERO
var knockback_distance = 200

func _physics_process(delta):

	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
		WANDER:
			pass
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				var direction = position.direction_to(player.global_position)
				velocity = velocity.move_toward(direction * MAX_SPEED , ACCELERATION * delta)
			else:
				state = IDLE
		
	move_and_slide()			
		
func seek_player():
	if playerDetectionZone.can_see_player() == true:
		state = CHASE
	
func _on_hurtbox_area_entered(area):
	stats.health -= area.damage
	velocity = (area.knockback_vector * knockback_distance)
	hurtbox.create_hit_effect()


func _on_stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instantiate()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
	
