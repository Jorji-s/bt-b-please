extends Node2D
@export var ecrimThough:=0
@export var evalidThough:=0
@export var ecrimAway:=0
@export var evalidAway:=0
@export var efalseDetains:=0
@export var emissedDetains:=0
@export var ecorrectDetains:=0
@export var etimeTaken:=0.0
@onready var button: Button = $ColorRect/Control/Button
@onready var button_2: Button = $ColorRect/Control/Button2


@onready var updated_values: Label = $ColorRect/Control/updatedValues
@onready var day_label: Label = $ColorRect/Control/dayLabel
@onready var day_label_2: Label = $ColorRect/Control/dayLabel2
@onready var rich_text_label: RichTextLabel = $ColorRect/Control/RichTextLabel
@onready var button_3: Button = $ColorRect/Control/Button3
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var totalScore:=0
var rank:=0
var etotalscore:=0
var curMoney:=0
var canBuy:=false

func _ready() -> void:
	await get_tree().create_timer(1.0).timeout
	var totalTween=create_tween()
	totalTween.tween_property(self,"totalScore",Manager.dayEarningMoney,1.5)
	await get_tree().create_timer(1.6).timeout
	Input.mouse_mode=Input.MOUSE_MODE_VISIBLE
	totalScore=0
	Manager.totalMoney+=Manager.dayEarningMoney
	canBuy=true
	button_3.disabled=false
func _process(delta: float) -> void:	
	updated_values.text="\nDay "+str(Manager.day)+"/14\n\nSavings Goal: $50000\n\nCurrent Savings: $"+str(Manager.totalMoney+totalScore)
	button.text="Upgrade Computer Boot Speed x"+str(Manager.printerSpeedUpgrades+1)+"\nCost: $1500"
	button_2.text="Upgrade Printer Print Time x"+str(Manager.printerPrintSpeed+1)+"\nCost: $2500"


func _on_button_pressed() -> void:
	if Manager.totalMoney>=1500 && canBuy:
		Manager.printerSpeedUpgrades+=1
		Manager.totalMoney-=1500
		totalScore=1500
		var totalTween=create_tween()
		totalTween.tween_property(self,"totalScore",0,1.0)


func _on_button_2_pressed() -> void:
	if Manager.totalMoney>=2500 && canBuy:
		Manager.printerPrintSpeed+=1
		Manager.totalMoney-=2500
		totalScore=2500
		var totalTween=create_tween()
		totalTween.tween_property(self,"totalScore",0,1.0)


func _on_button_3_pressed() -> void:
	animation_player.play_backwards("fdeIn")
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
	await get_tree().create_timer(0.6).timeout
	Manager.day+=1
	get_tree().change_scene_to_file("res://mainWorld/main_world.tscn")
