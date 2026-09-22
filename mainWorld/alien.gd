# Author: asher
extends Node3D
@onready var modulator: Sprite3D = $modulator
@onready var human_guy: Sprite3D = $modulator/humanGuy
@onready var test_alien_1: Sprite3D = $modulator/testAlien1
@onready var trait_displayer: Label3D = $traitDisplayer
signal atCounter
signal leftCounter
signal wrongChoice(reason : String)
signal rightChoice

#as this number goes up, the issues that documents could have get more obscure and harder to notice
@export var dayNumber:=1
var planetList:=[]
var fakePlanetList:=[]
var speciesList:=[]
var nameList:=[]
var descList:=[]
var solarSystemPlanets:=["Mercury","Venus","Earth","Mars","Jupiter","Saturn","Uranus","Neptune","Pluto","Europa","Earth","Earth","Earth","Earth","Earth","Earth","Earth","Earth","Earth","Earth"]
var tripPorpoises=["Business","Vacation","Meeting Family","Pleasure","Religion","Asylum","Immigrating","Funeral","Marriage"]
@export var bannedPlanets:=[]
@export var criminalNames:=["",""]

@onready var move_animator: AnimationPlayer = $moveAnimator

@onready var sprite_list = modulator.get_children()
@onready var num_sprites = sprite_list.size()
@onready var display_sprite = sprite_list[0]
@export var shouldLetThrough:=false
@export var shouldDetain:=false
var alienID=0;

@export var species:="Glorpian" #Species of alien. needs to match sprite to be correct
@export var alName:="Gleep Glorp" #Name of the alien. needs to match what they tell you if you ask to be correct
@export var physDesc:="Green skin with many tentacles and eyes" # needs to match the aliens look to be correct
@export var tickDesc:="Green skin with many tentacles and eyes" # needs to match the aliens look to be correct
@export var birthDate:="0916-2026"  #needs to be less than the current date to be correct
@export var passExpirDate:="8675-3090" #needs to be more than the current date to be correct
@export var planetOfBirth:="Glorp" #Needs to be a real planet to be correct

@export var tickSpecies:="Glorpian"
@export var tickName:="Gleep Glorp"
@export var destination:="Mars" #Needs to be a planet in the solar system to be correct
@export var departureLocation:="Glorp" #Needs to be a real planet to be correct
@export var tripType:="One-Way" #Doesnt mean anything
@export var tripPurpose:="Visiting Family" #Needs to match what the alien tells you to be correct
@export var tripDate:="0712-2029" #Needs to be the current date to be correct
@export var IDNumber:="51-203-4152" #doesnt mean anything at the moment, suggest an idea if you have it
@export var needsEarthDocument:=false #becomes true if the day is right and the person is going to earth
@export var hasEarthDocument:=false #becomes true if the alien is given the document and needs it

@export var banPlanet:=false


@export var currentDate1:=0000
@export var currentDate2:=0000

@export var chanceOfBeingRight:=0.35 #percent chance of the alien being ok to let through, cant be bigger than 1 or less than 0, the lower the number the less chance they have of being right. Will probably change every day
@export var chanceOfNeedingDetained:=0.0 #percent chance of needing to be detained, only rolls if the person already shouldnt go through
@onready var interaction_component: Area3D = $InteractionComponent
var sentAway:=false
var decisionMade:=""
var thingWrong:="Hurt my\nfeelings :("

func _ready():
	await get_tree().create_timer(0.1).timeout
	var planetFile := FileAccess.open("res://data text files/planet_names.txt", FileAccess.READ)
	var content := planetFile.get_as_text()
	planetList = content.split("\n", false)  # false removes empty lines
	var bannedPlanCount=randi_range(3,10)
	bannedPlanets.resize(bannedPlanCount)
	var increment=0
	var startInd=randi_range(0,planetList.size()-bannedPlanCount-1)
	for i in range(bannedPlanCount):
		bannedPlanets[increment]=planetList[startInd+increment]
		planetList[startInd+increment]="Wolftopia"
		increment+=1
	
	
	
		
		
	var speciesFile := FileAccess.open("res://data text files/species_names.txt", FileAccess.READ)
	content = speciesFile.get_as_text()
	speciesList = content.split("\n", false)  # false removes empty lines
	var nameFile := FileAccess.open("res://data text files/alien_names.txt", FileAccess.READ)
	content = nameFile.get_as_text()
	nameList = content.split("\n", false)  # false removes empty lines
	var descFile := FileAccess.open("res://data text files/species_desc.txt", FileAccess.READ)
	content = descFile.get_as_text()
	descList = content.split("\n", false)  # false removes empty lines
	
	var fakeplanetFile := FileAccess.open("res://data text files/fakeplanet_names.txt", FileAccess.READ)
	var fakecontent := fakeplanetFile.get_as_text()
	fakePlanetList = fakecontent.split("\n", false)  # false removes empty lines
	
	
	var wantedCrimCount=randi_range(3,5)
	criminalNames.resize(wantedCrimCount)
	var increment2=0
	for i in range(wantedCrimCount):
		criminalNames[increment2]=nameList[randi_range(0,nameList.size()-1)]+" "+nameList[randi_range(0,nameList.size()-1)]
		increment2+=1
	
	
	

	
	if dayNumber<7:
		chanceOfNeedingDetained=0
	if dayNumber==7:
		chanceOfNeedingDetained=0.2
	if dayNumber>=8:
		chanceOfBeingRight=randf_range(0.2,0.4)
		chanceOfNeedingDetained=0.1
	if dayNumber>=10:
		banPlanet=true
	if dayNumber==10:
		chanceOfNeedingDetained=0.333
	if dayNumber>=11:
		chanceOfNeedingDetained=0.2
	
	
	
	
	hide_sprites()
	randomize()
	print(str(num_sprites) + " alien designs loaded.")
	randomize_sprite()

# Hides the previous display sprite
# Chooses a random sprite from the sprite_list
# Assigns display sprite to this one and unhides it
func randomize_sprite():
	interaction_component.disable()
	display_sprite.visible = false
	var selector = randi_range(0,num_sprites - 1)
	alienID=selector
	display_sprite = sprite_list[selector]
	display_sprite.visible = true
	shouldLetThrough=randf_range(0,1)<chanceOfBeingRight
	if !shouldLetThrough:
		shouldDetain=randf_range(0,1)<chanceOfNeedingDetained
	assignTraits(alienID)
	sentAway=false
# Utility function to hide all the child sprites of modulator
func hide_sprites():
	for sprite in sprite_list:
		sprite.visible = false

# Right now all this does is initiates some sample dialog
# Temporary
func _on_interaction_component_interacted() -> void:
	DialogManager.start_dialog(load_lines("res://dialog_lines/alien1.txt"))

# Loads lines from file
func load_lines(path: String):
	var lines: Array[String] = []
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		while not file.eof_reached():
			var line = file.get_line()
			if line.length() != 0:
				lines.append(line)
	return lines
	
#yes means they went right, no means they went left, detain means they got detained
func letThrough(answer: String):
	sentAway=true
	decisionMade=answer
	leftCounter.emit()
	interaction_component.disable()
	await get_tree().create_timer(0.5).timeout
	if answer=="yes":
		move_animator.play("letThrough")
	elif answer=="no":
		move_animator.play_backwards("showUp")
	else:
		await get_tree().create_timer(1.0).timeout
		move_animator.play_backwards("showUp")


func assignTraits(ID):
	species=speciesList[ID]
	alName=nameList[randi_range(0,nameList.size()-1)]+" "+nameList[randi_range(0,nameList.size()-1)]
	tickSpecies=species
	tickName=alName
	physDesc=descList[ID]
	tickDesc=descList[ID]
	birthDate=str(randi_range(currentDate1,9999))+"-"+str(randi_range(1000,currentDate2))
	passExpirDate=str(randi_range(currentDate1,9999))+"-"+str(randi_range(currentDate2,9999))
	planetOfBirth=planetList[randi_range(0,planetList.size()-1)]
	
	destination=solarSystemPlanets[randi_range(0,solarSystemPlanets.size()-1)]
	departureLocation=planetList[randi_range(0,planetList.size()-1)]
	tripPurpose=tripPorpoises[randi_range(0,tripPorpoises.size()-1)]
	tripDate=str(currentDate1)+"-"+str(currentDate2) #TEMPORARY, JUST ASSIGNS RANDOM NUMBERS
	IDNumber=str(randi_range(0,9))+" "+str(randi_range(1,9))+" - "+str(randi_range(1,9))+" "+str(randi_range(1,9))+" "+str(randi_range(1,9))+" - "+str(randi_range(1,9))+" "+str(randi_range(1,9))+" "+str(randi_range(1,9))+" "+str(randi_range(1,9))
	
	if shouldLetThrough:
		if destination=="Earth" && dayNumber>=5:
			needsEarthDocument=true
			thingWrong="Missing\nProper\nDocuments"
	
	if !shouldLetThrough:
		var issue=0
		
		if dayNumber==1:
			issue=randi_range(1,3) 
		if dayNumber==2:
			issue=randi_range(1,3) 
		if dayNumber==3:
			issue=randi_range(0,3) #introduces checking computer date
		if dayNumber==4:
			issue=randi_range(0,4) #introduces expired passport
		if dayNumber==5:
			issue=randi_range(0,4) #introduces the printer
		if dayNumber==6:
			issue=randi_range(4,8) #introduces invalid planet names
		if dayNumber==7:
			issue=randi_range(4,8) #introduces wanted criminals
		if dayNumber==8:
			issue=randi_range(0,9) #all current mechanics
		if dayNumber==9:
			issue=randi_range(0,9) #just a harder day 8
		if dayNumber==10:
			issue=randi_range(0,9) #adds banned planets
		if dayNumber>=11:
			issue=randi_range(0,9) #final gauntlet
		
		print(issue)
		
		if shouldDetain:
			if banPlanet:
				issue=randi_range(10,11)
			else:
				issue=11
		if issue==0:
			thingWrong="Invalid\nTrip Date"
			var errType=randi_range(0,2)
			if errType==0:
				tripDate=str(randi_range(1000,9999))+"-"+str(randi_range(1000,9999))
			elif errType==1:
				tripDate=str(currentDate1+randi_range(-5,-1))+"-"+str(currentDate2+randi_range(-1,1))
			else:
				tripDate=str(currentDate1+randi_range(1,5))+"-"+str(currentDate2+randi_range(-1,1))
				
		if issue==1:
			thingWrong="Mismatched\nIdentity\nDocuments"
			alName=nameList[randi_range(0,nameList.size()-1)]+" "+nameList[randi_range(0,nameList.size()-1)]
		if issue==2:
			thingWrong="Invalid\nDescription"
			var errType=randi_range(0,1)
			if errType==0:
				if ID!=0:
					physDesc=descList[randi_range(0,ID-1)]
				else:
					physDesc=descList[randi_range(1,9)]
			else:
				if ID!=10:
					physDesc=descList[randi_range(ID+1,9)]
				else:
					physDesc=descList[randi_range(0,8)]
			tickDesc=physDesc
		if issue==3:
			thingWrong="Invalid\nDescription"
			var errType=randi_range(0,1)
			if errType==0:
				if ID!=0:
					tickDesc=descList[randi_range(0,ID-1)]
				else:
					tickDesc=descList[randi_range(1,9)]
			else:
				if ID!=10:
					physDesc=descList[randi_range(ID+1,9)]
				else:
					physDesc=descList[randi_range(0,8)]
		if issue==4:
			thingWrong="Expired\nPassport"
			passExpirDate=str(randi_range(1000,9999))+"-"+str(randi_range(1000,currentDate2-1))
		if issue==5:
			thingWrong="Mismatched\nSpecies\nRecords"
			var random=randi_range(0,speciesList.size()-1)
			tickSpecies=speciesList[random]
			if tickSpecies==species:
				if random!=9:
					tickSpecies=speciesList[random+1]
		if issue==6:
			thingWrong="Invalid\nDestination"
			destination=fakePlanetList[randi_range(0,fakePlanetList.size()-1)]
		if issue==7:
			thingWrong="Invalid\nDeparture\nLocation"
			departureLocation=fakePlanetList[randi_range(0,fakePlanetList.size()-1)]
		if issue==8:
			thingWrong="Invalid\nHome\nPlanet"
			planetOfBirth=fakePlanetList[randi_range(0,fakePlanetList.size()-1)]
		if issue==9:
			thingWrong="Invalid\nDate of\nBirth"
			birthDate=str(randi_range(1000,9999))+"-"+str(currentDate2+randi_range(1,6000))
		if issue==10:
			var errType=randi_range(0,1)
			if errType==1:
				thingWrong="Blacklisted\nPlanet Of\nBirth"
				planetOfBirth=bannedPlanets[randi_range(0,bannedPlanets.size()-1)]
			if errType==0:
				thingWrong="Blacklisted\nDeparture\nPlanet"
				departureLocation=bannedPlanets[randi_range(0,bannedPlanets.size()-1)]
		if issue==11:
			thingWrong="Blacklisted\nIndividual\nOverlooked"
			planetOfBirth=bannedPlanets[randi_range(0,bannedPlanets.size()-1)]
		
		
		
	
	trait_displayer.text="Species: "+species+"\nName: "+alName+"\nDesc: "+physDesc+"\nBirthdate: "+birthDate+"\npassExpirDate: "+passExpirDate+"\nPlanet of Origin: "+planetOfBirth+"\nDestination:"+destination+"\ndeparture loc: "+departureLocation+"\ntrip Type: "+tripType+"\ntrip Purpose: "+tripPurpose+"\ntrip Date: "+tripDate+"\nID Number: "+IDNumber+"\nIs Good to Go? "+str(shouldLetThrough)+" Should Detain? "+str(shouldDetain)


func _on_move_animator_animation_finished(anim_name: StringName) -> void:
	print(bannedPlanets)
	if anim_name=="showUp" && !sentAway:
		atCounter.emit()
		interaction_component.enable()
	if sentAway:
		if shouldDetain:
			if decisionMade=="yes" || decisionMade=="no":
				wrongChoice.emit(thingWrong)
			else:
				rightChoice.emit()
		else:
			if shouldLetThrough:
				if decisionMade=="yes":
					if needsEarthDocument:
						if hasEarthDocument:
							rightChoice.emit()
						else:
							wrongChoice.emit(thingWrong)
					else:
						rightChoice.emit()
				elif decisionMade=="no":
					wrongChoice.emit("Valid\n Individual\nRejected")
				else:
					wrongChoice.emit("Valid\n Individual\nDetained")
			else:
				if decisionMade=="no":
					rightChoice.emit()
				elif decisionMade=="yes":
					wrongChoice.emit(thingWrong)
				else:
					wrongChoice.emit("Unlawful\nDetainment")
		await get_tree().create_timer(randi_range(2,7)).timeout
		randomize_sprite()
		decisionMade=""
		move_animator.play("showUp")
		
