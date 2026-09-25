extends Node3D
@onready var timer: Timer = $Timer
var hasPaper:=false
@onready var sprite_3d: AnimatedSprite3D = $printerObj/Sprite3D
@onready var player: CharacterBody3D = $"../player"
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D

func _on_computer_obj_print_docu() -> void:
	timer.start(36/Manager.printerPrintSpeed)
	audio_stream_player_3d.play()
	audio_stream_player_3d.pitch_scale=Manager.printerPrintSpeed

func _on_timer_timeout() -> void:
	hasPaper=true
	sprite_3d.play("paper")


func _on_interaction_component_interacted() -> void:
	if hasPaper:
		hasPaper=false
		player.holdingPaper=true
	sprite_3d.play("noPaper")
