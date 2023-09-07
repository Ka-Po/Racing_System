extends VehicleBody3D


var pre_engine_force:bool=true

func _process(delta):
	
	if pre_engine_force == true:
		engine_force=0
	elif pre_engine_force == false:
		steering = Input.get_axis("d","a") * 0.4
		engine_force = Input.get_axis("s","w") * 100
