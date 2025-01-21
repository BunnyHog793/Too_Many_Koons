extends CharacterBody2D

@export var move_speed : float = 500
@export var roll_speed : float = 750
@export var roll_time : float = .2
@export var roll_timeout : float = .4

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
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	if Input.get_action_strength("roll") && not rolling:
		rolling = true
		$roll_timer.start(roll_time)
		$roll_timeout.start(roll_timeout)
		rolling_speed = roll_speed
		
	
	input_direction.normalized()
	
	velocity = input_direction * (move_speed + rolling_speed) 
	
	
		
	move_and_slide()


func _on_roll_timer_timeout():
	rolling_speed = 0
	


func _on_roll_timeout_timeout():
	rolling = false
