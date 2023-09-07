extends Timer

@onready var timeLable = get_node("Label")

#func _ready():
#	self.set_wait_time(2)
#	self.start()


func timer_start():
	self.set_wait_time(2)
	self.start()


var DisplayValue = 0
func _on_timeout():
	self.DisplayValue += 1

func _process(delta):

	timeLable.text = str(DisplayValue)
	
	
	
	pass
