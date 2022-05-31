extends Reference


static func sum(inputs, weights):
	var out = 0
	if not (len(inputs) == len(weights)):
		push_error("Inputs and weight are not same size")
	for i in range(0, len(inputs)):
		out += (inputs[i] * weights[i])
		
	return out

static func run_neuron_tanh(inputs, weights):
	var out = 0
	
	out = sum(inputs, weights)
	out = tanh(out)
	return out
