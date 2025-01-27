extends CharacterBody2D

@export var base_speed : float = 500
@export var move_speed : float = 500
@export var run_speed : float = 750
@export var roll_speed : float = 1000
@export var roll_time : float = .15
@export var roll_timeout : float = .2

var interact_object = null

var rolling : bool = false
var rolling_speed = 0

enum state {
	IDLE,
	MOVE,
	RUN,
	ROLL
}

# Called when the node enters the scene tree for the first time.
func _ready():
	rolling = false

func get_input_direction():
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	return input_direction

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var input_direction = get_input_direction()
	
	if Input.is_action_just_pressed("activate"):
		activate()
	
	if Input.is_action_just_pressed("roll") && not rolling:
		rolling = true
		$roll_timer.start(roll_time)
		$roll_timeout.start(roll_timeout)
		rolling_speed = roll_speed
		
	
	if Input.get_action_strength("run"):
		move_speed = run_speed
	else:
		move_speed = base_speed
	
	
	input_direction.normalized()
	
	velocity = input_direction * (move_speed + rolling_speed) 
	
	move_and_slide()


func _on_roll_timer_timeout():
	rolling_speed = 0
	


func _on_roll_timeout_timeout():
	rolling = false



		
func activate():
	if interact_object != null:
		interact_object.activated()



func _on_range_area_entered(area):
		if area.is_in_group("activatable"):
			interact_object = area
			print("added")


func _on_range_area_exited(area):
	interact_object = null
	print("left body")
