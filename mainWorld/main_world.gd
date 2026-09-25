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
@onready var beer_desk: Node3D = $desk/beerDesk

@export var AlienAtCounter:=false
@export var aliensServed:=-1
@export var curDate1=9021
@export var curDate2=3026
@onready var wanted_criminals: Label = $desk/computerObj/computerHUD/bootScreen/homeScreen/wantedList/wantedCriminals
@onready var plan_list_1: Label = $desk/computerObj/computerHUD/bootScreen/homeScreen/bannedPlanetList/planList1
@onready var plan_list_2: Label = $desk/computerObj/computerHUD/bootScreen/homeScreen/bannedPlanetList/planList2
@onready var notifications: Label = $desk/computerObj/computerHUD/bootScreen/homeScreen/messages/notifications
@onready var computer_obj: Node3D = $desk/computerObj
@onready var exit_interact: Area3D = $tempRoom/SouthWall2/exitInteract




func _ready() -> void:
	day=Manager.day
	alien.dayNumber=day
	if day>4:
		beer_desk.visible=true
	if day>6:
		Manager.detainUnlocked=true
	else:
		Manager.detainUnlocked=false
	detain_button.updateButton()
	
	if day>4:
		computer_obj.showsPrintfile=true
	if day>5:
		computer_obj.showsPlanetList=true
	if day>6:
		computer_obj.showsWantedList=true
	if day>9:
		computer_obj.showsBlackList=true
	
	if day==1:
		quota=3
		notifications.text="9020-3026 - WELCOME NEW EMPLOYEE\nUSE THE BUTTONS TO THE RIGHT OF YOUR DESK TO LET PEOPLE IN. DO NOT LET PEOPLE WITH IMPROPER DOCUMENTS IN. LEAVE ONCE QUOTA IS MET. SCREEN WILL GIVE FEEDBACK.\n\n\n9021-3026 - Hey Glarnk, just wanted to welcome you on the job! Don't have a whole lot to tell you, just confirm names and descriptions when you check documents!\nI always forget, good luck"
	if day==2:
		quota=5
		notifications.text="9021-3026 - Hey Glarnk, just wanted to welcome you on the job! Don't have a whole lot to tell you, just confirm names and descriptions when you check documents!\nI always forget, good luck\n\n\n9022-3026 - Sup Glarnk, I was wondering if you were doing anything after your shift today? My old drinking buddy got transfered, and I need a new one. You any good at space pool?"
	if day==3:
		quota=7
		notifications.text="9022-3026 - Sup Glarnk, I was wondering if you were doing anything after your shift today? My old drinking buddy got transfered, and I need a new one. You any good at space pool?\n\n\n9023-3026 - Hey Glarnk, some people have been getting by with invalid trip tickets, make sure you are checking the date! It needs to be today's date, not before or after."
	if day==4:
		quota=9
		notifications.text="9023-3026 - Hey Glarnk, some people have been getting by with invalid trip tickets, make sure you are checking the date! It needs to be today's date, not before or after.\n\n\n9024-3026 - Listen, Glarnk you haven't been checking people's passport expiration dates. I know we had a lot of fun drinking last night, but make sure you are checking their expiration date and rejecting them if they are after today's date. Looking forward to tonight"
	if day==5:
		quota=10
		notifications.text="9024-3026 - Listen, Glarnk you haven't been checking people's passport expiration dates. I know we had a lot of fun drinking last night, but make sure you are checking their expiration date and rejecting them if they are after today's date. Looking forward to tonight\n\n\n9025-3026 - NEW ANNOUNCEMENT:\nALL VISITORS GOING TO EARTH NOW REQUIRE AN EARTH PASS. APPROPRIATE DOCUMENTS HAVE BEEN LOADED ONTO EVERY COMPUTER"
	if day==6:
		quota=12
		notifications.text="9025-3026 - NEW ANNOUNCEMENT:\nALL VISITORS GOING TO EARTH NOW REQUIRE AN EARTH PASS. APPROPRIATE DOCUMENTS HAVE BEEN LOADED ONTO EVERY COMPUTER\n\n\n9026-3026 - Glarnk, my man, I just did you a huge favor. I loaded a list of every valid Federation planet onto your computer (mainly cause I can't remember them for the life of me). Buy me a space beer as thanks, cheers!"
	if day==7:
		quota=15
		notifications.text="9027-3026 - Glarnk, my man, I just did you a huge favor. I loaded a list of every valid Federation planet onto your computer (mainly cause I can't remember them for the life of me). Buy me a space beer as thanks, cheers!\n\n\n9028-3026 - NEW ANNOUNCEMENT:\nWANTED CRIMINALS HAVE BEEN SPOTTED IN YOUR SECTOR. A LIST OF NAMES HAS BEEN PROVIDED AND WILL UPDATE EACH DAY. DETAIN ANY SUSPECTED CRIMINALS ASAP"
	if day==8:
		quota=18
		notifications.text="9028-3026 - NEW ANNOUNCEMENT:\nWANTED CRIMINALS HAVE BEEN SPOTTED IN YOUR SECTOR. A LIST OF NAMES HAS BEEN PROVIDED AND WILL UPDATE EACH DAY. DETAIN ANY SUSPECTED CRIMINALS ASAP\n\n\n9029-3026 - Glarnk, listen buddy, I think some things are going down in this sector. I overhead the bosses talking about upping security, and preparing to bail of things get bad. Keep an eye out, alright man?"
	if day==9:
		quota=24
		notifications.text="9029-3026 - Glarnk, listen buddy, I think some things are going down in this sector. I overhead the bosses talking about upping security, and preparing to bail of things get bad. Keep an eye out, alright man?\n\n\n9030-whatever, it doesnt matter anymore. Listen, Glarnk, you won't hear from me for a while. Things are getting bad, and I'm leaving. I'll buy you a drink when I see you, alright?\nStay safe. -Your friend, Kleek"
	if day==10:
		quota=27
		notifications.text="9030-whatever, it doesnt matter anymore. Listen, Glarnk, you won't hear from me for a while. Things are getting bad, and I'm leaving. I'll buy you a drink when I see you, alright?\nStay safe. -Your friend, Kleek\n\n\n9031-3026 - NEW ANNOUNCEMENT:\nGALACTIC WAR HAS ERUPTED. ALL PLANETS BELONGING TO THE ENEMY HAVE BEEN BLACKLISTED. DETAIN ANYONE FROM OR LEAVING FROM BLACKLISTED PLANETS"
	if day==11:
		quota=30
		notifications.text="9030-whatever, it doesnt matter anymore. Listen, Glarnk, you won't hear from me for a while. Things are getting bad, and I'm leaving. I'll buy you a drink when I see you, alright?\nStay safe. -Your friend, Kleek\n\n\n9031-3026 - NEW ANNOUNCEMENT:\nGALACTIC WAR HAS ERUPTED. ALL PLANETS BELONGING TO THE ENEMY HAVE BEEN BLACKLISTED. DETAIN ANYONE FROM OR LEAVING FROM BLACKLISTED PLANETS"
	if day==12:
		quota=35
		notifications.text="9030-whatever, it doesnt matter anymore. Listen, Glarnk, you won't hear from me for a while. Things are getting bad, and I'm leaving. I'll buy you a drink when I see you, alright?\nStay safe. -Your friend, Kleek\n\n\n9031-3026 - NEW ANNOUNCEMENT:\nGALACTIC WAR HAS ERUPTED. ALL PLANETS BELONGING TO THE ENEMY HAVE BEEN BLACKLISTED. DETAIN ANYONE FROM OR LEAVING FROM BLACKLISTED PLANETS"
	if day==13:
		quota=40
		notifications.text="9030-whatever, it doesnt matter anymore. Listen, Glarnk, you won't hear from me for a while. Things are getting bad, and I'm leaving. I'll buy you a drink when I see you, alright?\nStay safe. -Your friend, Kleek\n\n\n9031-3026 - NEW ANNOUNCEMENT:\nGALACTIC WAR HAS ERUPTED. ALL PLANETS BELONGING TO THE ENEMY HAVE BEEN BLACKLISTED. DETAIN ANYONE FROM OR LEAVING FROM BLACKLISTED PLANETS"
	if day==14:
		quota=45
		notifications.text="9031-3026 - NEW ANNOUNCEMENT:\nGALACTIC WAR HAS ERUPTED. ALL PLANETS BELONGING TO THE ENEMY HAVE BEEN BLACKLISTED. DETAIN ANYONE FROM OR LEAVING FROM BLACKLISTED PLANETS\n\n\n9032-3026 - NEW ANNOUNCEMENT:\nENEMY FLEETS ARE APPROACHING THIS SECTOR. MANAGERIAL PERSONAL PLEASE REPORT TO DESIGNATED ESCAPE PODS. ESSENTIAL STAFF BEHAVE AS USUAL"
	if day>14:
		quota=day*4
		
	Manager.quotaRef=quota
	
	
	tv.updateTV()
	#Generates the banned planets
	
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
	alien.currentDate1=curDate1
	alien.currentDate2=curDate2
	currentDate=str(curDate1)+"-"+str(curDate2)
	await get_tree().create_timer(0.2).timeout
	bannedPlans=alien.bannedPlanets
	criminalList=alien.criminalNames
	for f in range(criminalList.size()):
		wanted_criminals.text+=criminalList[f]+"\n"
	for f in range(bannedPlans.size()/2):
		plan_list_1.text+=bannedPlans[f]+"\n"
		plan_list_2.text+=bannedPlans[f+bannedPlans.size()/2]+"\n"
	print(criminalList)

func _process(delta: float) -> void:
	Manager.timeTaken+=1*delta



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
	await get_tree().create_timer(5.0).timeout
	print(aliensServed)
	if aliensServed>=quota-2:
		print("DONEW ITH THE DAY")
		doneDay()
	
func doneDay()->void:
	alien.done=true
	exit_interact.global_position.y+=20
