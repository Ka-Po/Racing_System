extends Node3D

var CP#CheckPoint不能先定義為陣列:Array
var currCP:Array# 要先定義為陣列
var PlusCP:Array# 要先定義為陣列

#var Obj#:Array
var ObjSort:Array

var Obj_To_CurrCP_length:Array
var Obj_To_CurrCP_Sort_length:Array

var Obj_Pos#:Array

@onready var Obj = [preload("res://rigid_body_3d.tscn"),preload("res://rigid_body_3d_2.tscn"),preload("res://rigid_body_3d_3.tscn")]

var Obj_InstanceNumber = 3

var Obj_ins:Array

#var AiObj_CurrCP:Array

@onready var myObj = Obj[0]#preload("res://rigid_body_3d.tscn")


var MyObjPos
var MyCurrCP
var MyObjtoCurrCP_length
var MyObj
var MyObj_To_CurrCP_Sort_length

func _ready():
	
	if CP==null :
		CP = $"../CheckPoint".get_children()
	
	if Obj_Pos==null:
		Obj_Pos = $"../Obj_Position".get_children()
	
	#print(Obj_Pos.size())
	
	#Obj_InstanceNumber = 3#Obj_Pos.size() - 0
	
	Obj_ins.resize(Obj_InstanceNumber)#resize是由1數起
	Obj_ins.fill(0)
	
	
	for x in $"../CheckPoint".get_children():
		x.connect("AreaPass",Callable(self,"getAreaSignal"))
#
	currCP.resize(Obj_InstanceNumber)
	currCP.fill(0)
	
	PlusCP.resize(Obj_InstanceNumber)
	PlusCP.fill(0)
	
	Obj_To_CurrCP_length.resize(Obj_InstanceNumber)
	Obj_To_CurrCP_length.fill(0)
	
	Obj_To_CurrCP_Sort_length.resize(Obj_InstanceNumber)
	Obj_To_CurrCP_Sort_length.fill(0)
	
	ObjSort.resize(Obj_InstanceNumber)#resize是由1數起
	ObjSort.fill(0)
	
	#=========================
	
	MyObjPos = randi() % (Obj_InstanceNumber)#我的汔車，隨機選位置
	
	print(MyObjPos)
	
	#for i in range(Obj_InstanceNumber-1,-1,-1):
	for i in range((Obj_InstanceNumber)):
		if i == MyObjPos :

			MyObj = myObj.instantiate()
			#MyCurrCP = 0
			MyObj.set_name("selfCar")
			MyObj.transform.origin = Obj_Pos[i].transform.origin
			#add_child(MyObj)
			$"../Obj".add_child(MyObj)
			
			print("MyObj instance")
			
			var CarCamera = preload("res://car_camera_3d.tscn").instantiate()
			#MyObj.get_child(2).transform.origin = CarCamera.transform.origin
			CarCamera.transform.origin = MyObj.get_child(2).transform.origin
			
			MyObj.get_child(2).add_child(CarCamera)
			CarCamera.make_current()
			
			print(MyObj.get_child(2).transform.origin)
			print(MyObj.transform.origin)

			MyObjtoCurrCP_length = (CP[currCP[MyObjPos]].get_global_transform().origin - MyObj.get_global_transform().origin).length()

			MyObj_To_CurrCP_Sort_length=500.0*PlusCP[currCP[MyObjPos]]-MyObjtoCurrCP_length

			ObjSort[MyObjPos]=[MyObj_To_CurrCP_Sort_length,"selfCar"]
			
			#print(ObjSort[i])
		
		
		else:
		#randomize()# 公式：randi() % arr1.size()#用隨機公式前要先加上這個randomize，稱隨機的種子
			var Randon_Obj = randi() % (Obj.size())#隨機選汔車

			Obj_ins[i] = Obj[Randon_Obj].instantiate()

			#Obj_ins[i].set_name("ai")

			#AiObj_CurrCP[i] = 0

			Obj_ins[i].transform.origin = Obj_Pos[i].transform.origin

			$"../Obj".add_child(Obj_ins[i])

			print("Ai_Obj instance",i)

			Obj_To_CurrCP_length[i] = (CP[currCP[i]].get_global_transform().origin - Obj_ins[i].get_global_transform().origin).length()
			
			Obj_To_CurrCP_Sort_length[i]=500.0*PlusCP[currCP[i]]-Obj_To_CurrCP_length[i]
			ObjSort[i]=[Obj_To_CurrCP_Sort_length[i],i]
			
			#print(Obj_To_CurrCP_length[i])
			#print(ObjSort[i])

		
		
	
	ObjSort.sort()
	ObjSort.reverse()
	#以下部份的ObjSort有時候不能讀取
	#for y in range(0,Obj_InstanceNumber,1):#順序顯示
	for y in range((Obj_InstanceNumber)):
		print(ObjSort[y][0],":",ObjSort[y][1])
	print("\n")


func _process(_delta):
	
	MyObjtoCurrCP_length = (CP[currCP[MyObjPos]].get_global_transform().origin - MyObj.get_global_transform().origin).length()
	MyObj_To_CurrCP_Sort_length=500.0*PlusCP[MyObjPos]-MyObjtoCurrCP_length
	ObjSort[MyObjPos]=[MyObj_To_CurrCP_Sort_length,"selfCar"]
	
	
	
	#print(ObjSort[MyObjPos][0],":",ObjSort[MyObjPos][1])
	
	
#
	for x in range(Obj_InstanceNumber-1,-1,-1):
	#for x in range((Obj_InstanceNumber)):
		if x!=MyObjPos :#&& Obj_To_CurrCP_length[x] != 0:
			Obj_To_CurrCP_length[x] = (CP[currCP[x]].get_global_transform().origin - Obj_ins[x].get_global_transform().origin).length()
			Obj_To_CurrCP_Sort_length[x]=500.0*PlusCP[x]-Obj_To_CurrCP_length[x]
			ObjSort[x]=[Obj_To_CurrCP_Sort_length[x],x]
		pass
#
#
	ObjSort.sort()
	ObjSort.reverse()
	#for y in range(0,Obj_InstanceNumber,1):#順序顯示
	for y in range((Obj_InstanceNumber)):
		print(ObjSort[y][0],":",ObjSort[y][1])
	print("\n")
	
	pass

func getAreaSignal(aCP,aRB):
#
	print("Now Check Point:",aCP)
	print("Now RigidBody3D:",aRB)
#
	if currCP[aRB]==aCP:

		if currCP[aRB] == CP.size() - 1:
			currCP[aRB] = 0
			PlusCP[aRB] += 1
			print("Full Pass!")
		else :
			currCP[aRB] += 1
			PlusCP[aRB] += 1
			print("Pass!")
			print("Obj :",aRB," Need Check Point :",currCP[aRB],)
#
##	if currCP == aCP:
##		currCP+=1
##		print(currCP)
	
	pass


