extends CharacterBody2D
class_name koon
@export_category("base stats")
@export var hp = 5

@export_category("Movement")
@export var base_speed : float = 500
@export var move_speed : float = 500
@export var run_speed : float = 750
@export var deceleration : float = 0.1

@export_category("rolling")
@export var roll_speed : float = 1000
@export var roll_time : float = .15
@export var roll_timeout : float = .25

@export_category("Other")

@onready var animation_player: AnimationPlayer = $AnimationPlayer


var interact_objects = []
#var last_dir = Vector2.ZERO
var rolling : bool = false
var rolling_speed = 0
var locked = false
var input_direction

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
	get_input_direction()
	activate()
	roll()
	run()
	slide_down()
	flip()
	move_and_slide()

# slow down due to friction
func slide_down():
	if input_direction.x != 0 || input_direction.y != 0:
		velocity = input_direction * (move_speed + rolling_speed)
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed * deceleration)
		velocity.y = move_toward(velocity.y, 0, move_speed * deceleration)

#run logic
func run():
	if Input.get_action_strength("run"):
		move_speed = run_speed
	else:
		move_speed = base_speed
		
# get wasd input
func get_input_direction():
	if !locked:
		input_direction = Vector2(
			Input.get_action_strength("right") - Input.get_action_strength("left"),
			Input.get_action_strength("down") - Input.get_action_strength("up")
		).normalized()

#roll logic
func roll() -> void:
	if Input.is_action_just_pressed("roll") && not rolling && input_direction != Vector2.ZERO:
		#locked = true
		animation_player.play("roll")
		rolling = true
		rolling_speed = roll_speed
		rolling_timeout()
		await get_tree().create_timer(roll_time).timeout
		rolling_speed = 0

#timeout for roll
func rolling_timeout():
	await get_tree().create_timer(roll_timeout).timeout
	rolling = false
	locked = false

# collect and enteract logic
func activate():
	if Input.is_action_just_pressed("activate"):
		var closest = null
		var dist = 100000
		if interact_objects != null:
			for object in interact_objects:
				var distance = position.distance_squared_to(object.position)
				if (distance < dist):
					closest = object
					dist = distance
		if closest != null:
			closest.activated()


func _on_range_area_entered(area):
		if area.is_in_group("activatable"):
			interact_objects.append(area)
			print("added")


func _on_range_area_exited(area):
	var removed = interact_objects.find(area)
	interact_objects.remove_at(removed)
	print("left body")

func flip():
	if velocity.x > 0:
		scale.x = scale.y * 1
	else:
		scale.x = scale.y * -1
