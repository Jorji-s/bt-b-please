extends Node3D
@onready var puterimatir: AnimationPlayer = $computerHUD/puterimatir
@onready var player: CharacterBody3D = $"../../player"
@onready var progress_bar: ColorRect = $computerHUD/bootScreen/progressBar
@onready var home_screen: Sprite2D = $computerHUD/bootScreen/homeScreen

var compOn:=false
var maxBarSize:=262.025
var buffering:=false
var fastLoad:=false
var onMainScreen:=false

func _process(delta: float) -> void:
	if compOn && !onMainScreen:
		if progress_bar.size.x<maxBarSize:
			await get_tree().create_timer(randf_range(0.25,0.5)).timeout
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
			
			if progress_bar.size.x>maxBarSize:
				progress_bar.size.x=maxBarSize
				await get_tree().create_timer(randf_range(0.1,0.5)).timeout
				if !onMainScreen:
					onMainScreen=true
			
	elif compOn:
		home_screen.visible=true


func _on_interaction_component_interacted() -> void:
	puterimatir.play("openMonitor")
	if player.allow_moving:
		puterimatir.play("openMonitor")
		player.allow_moving=false
		fastLoad=randi_range(0,4)==0
		player.blurred=true
		player.allow_looking=false
		progress_bar.size.x=0
		await get_tree().create_timer(0.6).timeout
		compOn=true
	else:
		puterimatir.play_backwards("openMonitor")
		player.allow_moving=true
		player.allow_looking=true
		player.blurred=false
		compOn=false
		await get_tree().create_timer(0.5).timeout
		onMainScreen=false
		home_screen.visible=false
