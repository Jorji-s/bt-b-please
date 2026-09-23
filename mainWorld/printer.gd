extends Node3D
@onready var timer: Timer = $Timer
var hasPaper:=false
@onready var sprite_3d: AnimatedSprite3D = $printerObj/Sprite3D

func _on_computer_obj_print_docu() -> void:
		timer.start(randi_range(30,60)/Manager.printerPrintSpeed)


func _on_timer_timeout() -> void:
	hasPaper=true
	sprite_3d.play("paper")


func _on_interaction_component_interacted() -> void:
	hasPaper=false
	sprite_3d.play("noPaper")
