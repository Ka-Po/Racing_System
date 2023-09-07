extends Area3D

signal AreaPass(aCP,aRB)

var Obj

func _ready():
	
	if Obj==null :
		Obj = $"../../Obj".get_children()
	

func _on_body_entered(body):
	
	#if body.name == "RigidBody3D":
	
#	if body == Obj[1]:
#		emit_signal("AreaPass",self.get_index())
	
	#傳送CheckPoint與RigidBody3D的index
	emit_signal("AreaPass",self.get_index(),body.get_index())
	
#	print(self.get_index())
#	print(body.get_index())
	
#		print(self.get_index())
#
#		print("hi///////////////////////////////////////////////")
#
	pass # Replace with function body.

