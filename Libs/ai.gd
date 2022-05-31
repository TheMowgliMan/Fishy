extends Reference

class_name ArtificialIntelligence

# Get the AI utils
var util = preload("res://Libs/ai_util.gd")

# Stores different types
enum types {
	N_TANH,
	N_INPUT,
	N_OUTPUT
}

# Stores the neural network
# Each item has this format:
# ..., {"inputs" : [1, 2, 3], "weights" : [0.1, -0.1. 0.8], "last_output" : -0.3, "type" : types.N_TANH}, ...
var network = []

# Stores input neuron id's
var input_neurons = []

# Stores output neuron id's
var output_neurons = []


# Adds a new neuron
func add_neuron(input_from, weights = null, type = types.N_TANH):
	var inp = input_from
	var weight = weights
	
	if weights == null:
		weight = []
		
		for i in input_from:
			weight.append(rand_range(-1.00, 1.00))
			
	network.append({"inputs" : inp, "weights" : weight, "last_output" : 0, "type" : type})
	
	var in_id = len(network) - 1
	return in_id

func add_input(last_in):
	network.append({"inputs" : [], "weights" : [], "last_output" : last_in, "type" : types.N_INPUT})
	
	var in_id = len(network) - 1
	input_neurons.append(in_id)
	return in_id
	
func add_output(inputs, weights, last_out):
	network.append({"inputs" : inputs, "weights" : weights, "last_output" : last_out, "type" : types.N_OUTPUT})
	
	var in_id = len(network) - 1
	output_neurons.append(in_id)
	return in_id
	
func override_neuron(neuron, value):
	if not (neuron in input_neurons):
		push_warning("Neuron " + str(neuron) + " not in input filter.")
		
	# Clamp it to ensure it is a valid value
	network[neuron]["last_output"] = clamp(value, -1.0, 1.0)
	
func get_neuron(neuron):
	return network[neuron]["last_output"]
	
func run_network():
	for i in range(0, len(network)):
		var n = network[i]
		
		if n["type"] == types.N_TANH:
			var inputs = []
			for i2 in n["inputs"]:
				inputs.append(network[i2]["last_output"])
				
			var out = util.run_neuron_tanh(inputs, n["weights"])
			network[i]["last_output"] = out
		elif n["type"] == types.N_OUTPUT:
			var inputs = []
			for i2 in n["inputs"]:
				inputs.append(network[i2]["last_output"])
				
			var out = util.run_neuron_tanh(inputs, n["weights"])
			network[i]["last_output"] = out
