extends KinematicBody2D


var ai = ArtificialIntelligence.new()

# Stuff for controls
export var speed = 150
export var rot_speed = 3

# Get the raycasts' neuron id's
var r_left = 0
var r_right = 0
var r_up = 0
var r_down = 0

# Constant neuron
var con = 0

# Get direction and rotation neuron id's
var spd_id = 0
var rot_id = 0

# Velocity
var velocity = Vector2()

func bool_to_ai(inp):
	if inp:
		return 1
	else:
		return -1

func _ready():
	seed(OS.get_unix_time())
	
	r_left = ai.add_input(-1)
	r_right = ai.add_input(-1)
	r_up = ai.add_input(-1)
	r_down = ai.add_input(-1)
	
	con = ai.add_input(1)
	
	var spd_n = ai.add_neuron([con, r_right])
	var rot_n = ai.add_neuron([r_up, r_down, r_right])
	
	spd_id = ai.add_output([spd_n], [1], 0)
	rot_id = ai.add_output([rot_n], [1], 0)
	
func _process(delta):
	ai.override_neuron(r_left, bool_to_ai($Raycasts/Left.is_colliding()))
	ai.override_neuron(r_right, bool_to_ai($Raycasts/Right.is_colliding()))
	ai.override_neuron(r_up, bool_to_ai($Raycasts/Up.is_colliding()))
	ai.override_neuron(r_down, bool_to_ai($Raycasts/Down.is_colliding()))
	
	ai.run_network()
	
	var moving_speed = ai.get_neuron(spd_id) * speed
	var rotation_speed = ai.get_neuron(rot_id) * rot_speed
	
	velocity = Vector2(moving_speed, 0).rotated(rotation)
	rotation += rotation_speed * delta
	velocity = move_and_slide(velocity)
