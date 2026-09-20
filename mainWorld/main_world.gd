extends Node3D

func _ready() -> void:
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED

@export var AlienAtCounter:=false
@export var aliensServed:=0

func _on_alien_at_counter() -> void:
	await get_tree().create_timer(1.0).timeout
	aliensServed+=1
	AlienAtCounter=true


func _on_alien_left_counter() -> void:
	AlienAtCounter=false
