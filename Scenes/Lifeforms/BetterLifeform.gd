extends KinematicBody2D


var ai = ArtificialIntelligence.new()

# Stuff for controls
export var speed = 150
export var rot_speed = 6
export var view_extents = Vector2(100, 100)
export var see_behind = 0

# For eyes
export var body_type = "lifeform"

# Constant neuron
var con = 0

# Eye neurons
var barrier_angle_n = 0
var lifeform_angle_n = 0

# Get direction and rotation neuron id's
var spd_id = 0
var rot_id = 0

# Velocity
var velocity = Vector2(1, 1)

# Bodies in eyesight
var barriers_in = []
var lifeforms_in = []

func bool_to_ai(inp):
	if inp:
		return 1
	else:
		return -1

func _ready():
	$Eye/EyesCollider.shape.extents = view_extents
	$Eye/EyesCollider.position = Vector2(view_extents.x - see_behind, 0)
	
	barrier_angle_n = ai.add_input(-1)
	lifeform_angle_n = ai.add_input(-1)
	
	con = ai.add_input(1)
	
	var spd_n = ai.add_neuron([con], [1])
	var rot_n = ai.add_neuron([barrier_angle_n, lifeform_angle_n], [1, -1])
	
	spd_id = ai.add_output([spd_n], [1], 0)
	rot_id = ai.add_output([rot_n], [1], 0)

func _process(delta):
	var barrier_ang = _get_direction_to_bodies_in_array(barriers_in)
	var lifeform_ang = _get_direction_to_bodies_in_array(lifeforms_in)
	
	
	ai.override_neuron(barrier_angle_n, (barrier_ang) / 360)
	ai.override_neuron(lifeform_angle_n, (lifeform_ang) / 360)
	
	print((barrier_ang) / 180)
	
	ai.run_network()
	
	var moving_speed = ai.get_neuron(spd_id) * speed
	var rotation_speed = ai.get_neuron(rot_id) * rot_speed
	
	velocity = Vector2(moving_speed, 0).rotated(rotation)
	rotation += rotation_speed * delta
	velocity = move_and_slide(velocity)

func _on_Eye_body_entered(body):
	if body.body_type == "lifeform":
		lifeforms_in.append(body)
	else:
		barriers_in.append(body)

func _get_direction_to_bodies_in_array(array):
	var dir = 0
	var dirs = []
	
	for body in array:
		dirs.append(position.angle_to_point(body.position))
		
	for i in dirs:
		dir += i
		
	# print(dir)
		
	if len(dirs) > 0:
		dir = rotation_degrees - rad2deg(dir / len(dirs))
	
	return dir

func _on_Eye_body_exited(body):
	if body.body_type == "lifeform":
		lifeforms_in.erase(body)
	elif body.body_type == "barrier":
		barriers_in.erase(body)
