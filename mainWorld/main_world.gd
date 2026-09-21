extends Node3D
@onready var document_hud: Control = $Control/documentHUD
@onready var alien: Node3D = $alien
@onready var detain_cover_anim: AnimationPlayer = $detainButton/buttonCover/detainCoverAnim


func _ready() -> void:
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
	alien.currentDate1=curDate1
	alien.currentDate2=curDate2
	currentDate=str(curDate1)+"-"+str(curDate2)

@export var AlienAtCounter:=false
@export var aliensServed:=0
@export var curDate1=9021
@export var curDate2=3026

@export var currentDate:="6231-2032"
func _on_alien_at_counter() -> void:
	document_hud.updateLabels()
	detain_cover_anim.play("open")
	await get_tree().create_timer(1.0).timeout
	AlienAtCounter=true


func _on_alien_left_counter() -> void:
	detain_cover_anim.play_backwards("open")
	AlienAtCounter=false
