extends Node2D

var shouldClose:=false
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var computer_obj: Node3D = $"../../../.."
var coption:=0

func _ready() -> void:
	scale=Vector2.ZERO
	await get_tree().create_timer(1.0).timeout
	visible=false

func showDoc():
	if self.scale.x<0.05:
		animation_player.play("open")

func _input(event):
	if event.is_action_pressed("Interact") && (shouldClose||coption!=0) && computer_obj.hasDocuOpen:
		computer_obj.hasDocuOpen=false
		animation_player.play_backwards("open")
	if event.is_action_pressed("Interact") && coption==2:
		computer_obj.startPrint()
		
		
func _on_close_document_area_entered(area: Area2D) -> void:
	shouldClose=true


func _on_close_document_area_exited(area: Area2D) -> void:
	shouldClose=false


func _on_deny_print_pressed() -> void:
	if computer_obj.hasDocuOpen:
		computer_obj.hasDocuOpen=false
		animation_player.play_backwards("open")


func _on_click_no_area_entered(area: Area2D) -> void:
	if computer_obj.hasDocuOpen:
		coption=1


func _on_click_no_area_exited(area: Area2D) -> void:
	coption=0


func _on_click_yes_area_entered(area: Area2D) -> void:
	if computer_obj.hasDocuOpen:
		coption=2
