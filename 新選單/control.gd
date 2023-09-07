extends Control

var bg_Music:Array
var bg_Music_No:int = 0

func _ready():
	$SceneMenu/HBoxContainer/Scene1.call_deferred("grab_focus")
	
	bg_Music = $Sound.get_children()
	bg_Music[bg_Music_No].play()
	
	state = State.Menu
	
	pass

var fading:bool = false#聲音漸變：上載場境與暫停的時候

enum State{Menu,Loading,prePlay,Playing,endPlay}
var state = State.Menu

var ins_Timer:Timer
var ins_Car:VehicleBody3D

func _physics_process(delta):
#func _process(delta):
	match state:
		State.Menu:
			print("Menu!")
		State.Loading:
			print("Loading")
		
		State.prePlay:
			$Start_Animation.show()
			$Start_Animation/AnimationPlayer.play("Start_Lable")
			
			if Input.get_action_strength("return"):
				$Start_Animation/AnimationPlayer.stop()
				$Start_Animation.hide()
				
				if ins_Timer != null:
					ins_Timer.timer_start()
				
				if ins_Car != null:
					ins_Car.pre_engine_force=false
				
				
				state = State.Playing
			print("prePlay!")
		
		State.Playing:
			if ins_Timer != null:
				if ins_Timer.DisplayValue == 4:
					state = State.endPlay
					ins_Timer.stop()
			print("Playing!")
		
		State.endPlay:
			$Finish_Animation.show()
			$Finish_Animation/AnimationPlayer.play("Finish_Lable")
			
			if Input.get_action_strength("return"):
				$Finish_Animation/AnimationPlayer.stop()
				$Finish_Animation.hide()
				#state = State.Menu
				End_Play()
			print("endPlay!")
			#End_Play()
			pass
		
	
	if fading == true:
		if bg_Music[bg_Music_No].volume_db >-60:
			bg_Music[bg_Music_No].volume_db -= 30*delta
		if bg_Music[bg_Music_No].volume_db == -60:
			bg_Music[bg_Music_No].volume_db = -60
	else :
		if bg_Music[bg_Music_No].volume_db < 0:
			bg_Music[bg_Music_No].volume_db += 30*delta
		if bg_Music[bg_Music_No].volume_db == 0:
			bg_Music[bg_Music_No].volume_db = 0
	
	print("fading_volume db:",bg_Music[bg_Music_No].volume_db)
#	if fading == true:
#		if bg_Music[bg_Music_No].volume_db >-60:
#			bg_Music[bg_Music_No].volume_db -= 30*delta
#		if bg_Music[bg_Music_No].volume_db == -60:
#			bg_Music[bg_Music_No].volume_db = -60
#	else :
#		if bg_Music[bg_Music_No].volume_db < 0:
#			bg_Music[bg_Music_No].volume_db += 30*delta
#		if bg_Music[bg_Music_No].volume_db == 0:
#			bg_Music[bg_Music_No].volume_db = 0
	
	pass

#########---------轉移場境
var next_scene_instance: Node3D#回到主選單，會用到這個變數
var loading_screen = preload("res://loading_bar.tscn")

func _load_scene(current_scene,_scene,bg_music_no):
	
	var loading_screen_instance = loading_screen.instantiate()
	get_tree().get_root().call_deferred("add_child",loading_screen_instance)
	
	$SceneMenu.hide()#在這隱藏，可以避免轉場中途，在其他場境開啟選單
	
	state = State.Loading
	
	var load_path :String
	load_path = _scene
	
	var loader_nest_scene
	if ResourceLoader.exists(load_path):
		loader_nest_scene=ResourceLoader.load_threaded_request(load_path)
	
#	if loader_nest_scene == null:
#		print("error:non-exist _scene!")
#		return
	
	#current_scene.queue_free()#可以將場境下載
	
	while true:
		var load_progress = []
		var load_status = ResourceLoader.load_threaded_get_status(load_path,load_progress)
		await get_tree().create_timer(1.0).timeout
		
		match load_status:
#			0:
#				print("error:0")
#				return
			1:
				var progressBar = loading_screen_instance.get_node("ProgressBar")
				progressBar.value = load_progress[0] #* 100
				
#			2:
#				print("error:2")
#				return
			3:
				next_scene_instance = ResourceLoader.load_threaded_get(load_path).instantiate()
				get_tree().get_root().call_deferred("add_child",next_scene_instance)
				
				await get_tree().create_timer(0.2).timeout
				get_parent().move_child(self, 2)
				loading_screen_instance.queue_free()
				
				if _scene == "res://scene_1.tscn":
					ins_Timer = next_scene_instance.get_child(1).get_child(0)#指定位置取得計時器
				
				if _scene == "res://scene_2.tscn":
					ins_Car = next_scene_instance.get_child(1)#指定位置取得汔車
				
				
				bg_Music[bg_Music_No].stop()
				fading = false
				bg_Music_No=bg_music_no
				bg_Music[bg_Music_No].play()
				
				state = State.prePlay
				
				return
	
	pass

func _on_scene_1_pressed():
	#按制聲音
	_playBtn()
	_load_scene(null,"res://scene_1.tscn",0)
	fading = true
	pass

func _on_scene_2_pressed():
	_playBtn()
	_load_scene(null,"res://scene_2.tscn",1)
	fading = true
	pass

func _on_scene_3_pressed():
	_playBtn()
	_load_scene(null,"res://scene_3.tscn",2)
	fading = true
	pass

func _playBtn():
	$SoundFx/AudioStreamPlayer4.play()
	await get_tree().create_timer(0.32).timeout
	$SoundFx/AudioStreamPlayer4.stop()

#########---------Pausing

var music_position = 0

var _paused:bool = false:#預設false要配合，PauseMenu與get_tree().paused，它們都是預設false
	get:
		return _paused
	set(value):
		_paused = value
		#print("4")
		$PauseMenu.visible = value#!$PauseMenu.visible
		#print("5")
		get_tree().paused = value#!get_tree().paused
		
		if _paused == false:
			bg_Music[bg_Music_No].play(music_position)
			#fading = false#暫停後入音樂漸變，會變得不連貫之前的音樂
		else:
			music_position = bg_Music[bg_Music_No].get_playback_position()
			bg_Music[bg_Music_No].stop()
			#fading = true#暫停後入音樂漸變，會變得不連貫之前的音樂
		
		$PauseMenu/HBoxContainer/Resume.call_deferred("grab_focus")
		

func _input(event):
	#print("1")
	if(event.is_action_pressed("ui_cancel")):
		#print("2")
		#if $SceneMenu.visible==false:
		if state == State.Playing:
			#print("3")
			_paused = !_paused#將暫停時間與選單，結合到這個寫法內
			
		pass
		

func _on_resume_pressed():
	_paused = !_paused
	pass

func _on_menu_pressed():
	if is_instance_valid(next_scene_instance):
		_paused = !_paused
		next_scene_instance.queue_free()
		
		#await get_tree().create_timer(5.0).timeout
		
		back_to_menu()
	pass

func End_Play():
	if is_instance_valid(next_scene_instance):
		#_paused = !_paused
		next_scene_instance.queue_free()
		
		#await get_tree().create_timer(5.0).timeout
		
		back_to_menu()
	pass

func back_to_menu():
	
	state = State.Menu
	
	for number in range(bg_Music.size()):
		print(number)
		bg_Music[number].stop()
	
	#bg_Music[0].play()
	bg_Music_No = 0
	bg_Music[bg_Music_No].play()
	
	$SceneMenu.show()
	$SceneMenu/HBoxContainer/Scene1.call_deferred("grab_focus")
	pass
