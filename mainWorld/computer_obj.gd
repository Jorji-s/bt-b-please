extends Node3D
@onready var puterimatir: AnimationPlayer = $computerHUD/puterimatir
@onready var player: CharacterBody3D = $"../../player"
@onready var progress_bar: ColorRect = $computerHUD/bootScreen/progressBar
@onready var home_screen: Sprite2D = $computerHUD/bootScreen/homeScreen
@onready var cursor: TextureRect = $computerHUD/bootScreen/cursor
@onready var computer_hud: Control = $computerHUD
@onready var fade_2_white: ColorRect = $computerHUD/bootScreen/fade2White

var compOn:=false
var maxBarSize:=262.025
var buffering:=false
var fastLoad:=false
var onMainScreen:=false
var minutes:=15
var hours:=3
var mousePos := Vector2.ZERO
signal printDocu
var hasDocuOpen:=false
@onready var sprite_3d: Sprite3D = $Sprite3D


@export var showsPlanetList:=false
@export var showsWantedList:=false
@export var showsBlackList:=false
@export var showsPrintfile:=false
@onready var planet_text_icon: Sprite2D = $computerHUD/bootScreen/homeScreen/planetTextIcon
@onready var wanted_text_icon_2: Sprite2D = $computerHUD/bootScreen/homeScreen/wantedTextIcon2
@onready var blacklist_text_icon_3: Sprite2D = $computerHUD/bootScreen/homeScreen/blacklistTextIcon3
@onready var pass_icon: Sprite2D = $computerHUD/bootScreen/homeScreen/passIcon

@onready var date_label: Label = $computerHUD/bootScreen/homeScreen/dateLabel
@onready var top_right: Control = $computerHUD/bootScreen/fade2White/topRight
@onready var bottom_left: Control = $computerHUD/bootScreen/fade2White/bottomLeft
@onready var time_label: Label = $computerHUD/bootScreen/homeScreen/timeLabel
@onready var minute_timer: Timer = $computerHUD/minuteTimer

var shouldClose:=false

func _ready() -> void:
	await get_tree().create_timer(0.5).timeout
	if !showsPlanetList:
		planet_text_icon.global_position.y-=2000
		planet_text_icon.visible=false
	if !showsWantedList:
		wanted_text_icon_2.global_position.y-=2000
		wanted_text_icon_2.visible=false
	if !showsBlackList:
		blacklist_text_icon_3.global_position.y-=2000
		blacklist_text_icon_3.visible=false
	if !showsPrintfile:
		pass_icon.global_position.y-=2000
		pass_icon.visible=false

func _input(event):
	if compOn && event is InputEventMouseMotion:
		mousePos += event.relative  # use relative movement
	
	if event.is_action_pressed("Interact"):
		if !player.allow_moving && shouldClose:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			puterimatir.play_backwards("openMonitor")
			player.blurred=false
			compOn=false
			cursor.visible=false
			await get_tree().create_timer(0.5).timeout
			if !player.allow_moving:
				player.allow_moving=true
				player.allow_looking=true
				onMainScreen=false
				home_screen.visible=false
	
	if event.is_action_pressed("ui_cancel"):
		if !player.allow_moving && home_screen.visible:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			puterimatir.play_backwards("openMonitor")
			player.blurred=false
			compOn=false
			cursor.visible=false
			await get_tree().create_timer(0.5).timeout
			if !player.allow_moving:
				player.allow_moving=true
				player.allow_looking=true
				onMainScreen=false
				home_screen.visible=false
		
func _process(delta: float) -> void:
	if sprite_3d!=null:
		sprite_3d.look_at(player.global_position)
		sprite_3d.rotation.x=0
		sprite_3d.rotation.z=0
	mousePos.x = clamp(mousePos.x,  bottom_left.global_position.x, top_right.global_position.x-32*1.55)
	mousePos.y = clamp(mousePos.y, top_right.global_position.y, bottom_left.global_position.y-37)
	cursor.global_position = mousePos
	
	if compOn && !onMainScreen:
		if progress_bar.size.x<maxBarSize:
			Input.warp_mouse(Vector2.ZERO)
			await get_tree().create_timer(randf_range(0.25,0.5)).timeout
			if progress_bar.size.x<maxBarSize:
				if progress_bar.size.x>maxBarSize*0.25 && maxBarSize*0.8>progress_bar.size.x:
					if randi_range(0,100)==0:
						if !buffering:
							buffering=true
							await get_tree().create_timer(randf_range(3.0-Manager.printerSpeedUpgrades,5.0-Manager.printerSpeedUpgrades)).timeout
							buffering=false
							if progress_bar.size.x<maxBarSize*0.8:
								progress_bar.size.x+=randf_range(15,Manager.printerSpeedUpgrades*20)
				if !buffering:
					if progress_bar.size.x>maxBarSize*0.95 && !fastLoad:
						progress_bar.size.x+=randf_range(0.02*Manager.printerSpeedUpgrades,Manager.printerSpeedUpgrades*0.1)
					elif progress_bar.size.x>maxBarSize*0.9 && !fastLoad:
						progress_bar.size.x+=randf_range(0.05*Manager.printerSpeedUpgrades,Manager.printerSpeedUpgrades*0.2)
					else:
						progress_bar.size.x+=randf_range(0.25,Manager.printerSpeedUpgrades)
			
			if progress_bar.size.x>maxBarSize-0.1:
				progress_bar.size.x=maxBarSize
				await get_tree().create_timer(randf_range(0.1,0.5)).timeout
				if !onMainScreen:
					onMainScreen=true
					Input.warp_mouse(Vector2.ZERO)
					mousePos=Vector2.ZERO
					Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
					Input.set_custom_mouse_cursor(null)
					cursor.visible=true
			
	elif compOn:
		home_screen.visible=true
		cursor.visible=true


func _on_interaction_component_interacted() -> void:
	date_label.text="Date: "+str(get_parent().get_parent().curDate1)+"-"+str(get_parent().get_parent().curDate2)+" "
	if player.allow_moving:
		puterimatir.play("openMonitor")
		cursor.visible=false
		player.allow_moving=false
		fastLoad=randi_range(0,4)==0
		player.blurred=true
		player.allow_looking=false
		progress_bar.size.x=0
		await get_tree().create_timer(0.6).timeout
		compOn=true


func _on_minute_timer_timeout() -> void:
	minutes+=1
	if minutes>59:
		minutes=0
		hours+=1
	if minutes>9:
		time_label.text=str(hours)+":"+str(minutes)+" PM"
	else:
		time_label.text=str(hours)+":0"+str(minutes)+" PM"
	minute_timer.start()

func startPrint()->void:
	printDocu.emit()


func _on_area_2d_area_entered(area: Area2D) -> void:
	shouldClose=true


func _on_area_2d_area_exited(area: Area2D) -> void:
	shouldClose=false
