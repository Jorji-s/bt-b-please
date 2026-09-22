extends Node3D
@onready var document_hud: Control = $Control/documentHUD
@onready var alien: Node3D = $alien
@onready var detain_cover_anim: AnimationPlayer = $detainButton/buttonCover/detainCoverAnim
@export var bannedPlans:=[];
@export var criminalList:=[]
@export var planetList:=[];
@export var day:=0
@export var quota:=3
@onready var detain_button: CSGCombiner3D = $detainButton
@onready var tv: CSGCombiner3D = $TV

@export var AlienAtCounter:=false
@export var aliensServed:=-1
@export var curDate1=9021
@export var curDate2=3026

func _ready() -> void:
	day=Manager.day
	alien.dayNumber=day
	if day>6:
		Manager.detainUnlocked=true
	else:
		Manager.detainUnlocked=false
	detain_button.updateButton()
	if day==1:
		quota=3
	if day==2:
		quota=5
	if day==3:
		quota=7
	if day==4:
		quota=9
	if day==5:
		quota=10
	if day==6:
		quota=12
	if day==7:
		quota=15
	if day==8:
		quota=18
	if day==9:
		quota=24
	if day==10:
		quota=27
	if day==11:
		quota=30
	if day==12:
		quota=35
	if day==13:
		quota=40
	if day==14:
		quota=45
	if day>14:
		quota=day*4
	
	
	tv.updateTV()
	#Generates the banned planets
	
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
	alien.currentDate1=curDate1
	alien.currentDate2=curDate2
	currentDate=str(curDate1)+"-"+str(curDate2)
	await get_tree().create_timer(0.2).timeout
	bannedPlans=alien.bannedPlanets
	criminalList=alien.criminalNames
	print(criminalList)



@export var currentDate:="6231-2032"
func _on_alien_at_counter() -> void:
	
	document_hud.updateLabels()
	if(Manager.detainUnlocked):
		detain_cover_anim.play("open")
	await get_tree().create_timer(1.0).timeout
	AlienAtCounter=true


func _on_alien_left_counter() -> void:
	if(Manager.detainUnlocked):
		detain_cover_anim.play_backwards("open")
	AlienAtCounter=false
