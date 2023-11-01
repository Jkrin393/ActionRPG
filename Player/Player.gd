extends CharacterBody2D

@export var MAX_SPEED = 100
@export var ROLL_SPEED = 120
@export var ACCELERATION = 500
@export var FRICTION = 500

enum {
	MOVE,
	ROLL,
	ATTACK
}
var state = MOVE
var roll_vector = Vector2.DOWN
var input_vector = Vector2.ZERO
var stats = PlayerStats

@onready var animation_tree = $AnimationTree 
@onready var animation_player = $AnimationPlayer
@onready var animation_state = animation_tree.get("parameters/playback") #gets most recent animation state 
@onready var sword_hitbox = $HitboxPivot/SwordHitbox
@onready var hurtbox = $Hurtbox



func _ready():
	self.stats.connect("no_health", queue_free) # connect the player to the stats signal from Stats.gd to use the no health signal
	animation_tree.active = true
	sword_hitbox.knockback_vector = roll_vector 


func _physics_process(delta):
	#match statement for statemachine. Detemines which code block to run. acts like a switch statement
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state()
		ATTACK:
			attack_state(delta)

func move_state(delta):
	
	# Get the input direction, handle the movement speed, calculate vector
	input_vector.x =Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		sword_hitbox.knockback_vector = input_vector
		animation_tree.set("parameters/Idle/blend_position", input_vector) #sets blend position using vector in input_vector
		animation_tree.set("parameters/Run/blend_position", input_vector)
		animation_tree.set("parameters/Attack/blend_position", input_vector)
		animation_tree.set("parameters/Roll/blend_position", input_vector)
		animation_state.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animation_state.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move(velocity)
	
	if Input.is_action_just_pressed("roll"):
		state = ROLL
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK

func attack_state(delta):
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION/3.0 * delta)
	animation_state.travel("Attack")
	move(velocity)

func roll_state():
	velocity = roll_vector * ROLL_SPEED
	animation_state.travel("Roll")
	move(velocity)

		
func attack_animation_finished():
	state = MOVE

func roll_animation_finished():
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION/2)
	state = MOVE

func move(input_velocity):
	velocity = input_velocity
	move_and_slide()
	

func _on_hurtbox_area_entered(_area):
	self.stats.health -= 1
	hurtbox.start_invincibility(.5)
	hurtbox.create_hit_effect()
	print(self.stats.health)
