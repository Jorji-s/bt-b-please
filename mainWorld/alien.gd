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
@export var difficulty:=1
var planetList:=[]
var speciesList:=[]
var nameList:=[]
var descList:=[]
var solarSystemPlanets:=["Mercury","Venus","Earth","Mars","Jupiter","Saturn","Uranus","Neptune","Pluto","Europa"]
var tripPorpoises=["Business","Vacation","Meeting family","Pleasure","Religion","Asylum","Immigrating","Funeral","Marriage"]
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
@export var birthDate:="0916-2026"  #needs to be less than the current date to be correct
@export var passExpirDate:="8675-3090" #needs to be more than the current date to be correct
@export var planetOfBirth:="Glorp" #Needs to be a real planet to be correct

@export var destination:="Mars" #Needs to be a planet in the solar system to be correct
@export var departureLocation:="Glorp" #Needs to be a real planet to be correct
@export var tripType:="One-Way" #Doesnt mean anything
@export var tripPurpose:="Visiting Family" #Needs to match what the alien tells you to be correct
@export var tripDate:="0712-2029" #Needs to be the current date to be correct
@export var IDNumber:="51-203-4152" #doesnt mean anything at the moment, suggest an idea if you have it

@export var chanceOfBeingRight:=0.5 #percent chance of the alien being ok to let through, cant be bigger than 1 or less than 0, the lower the number the less chance they have of being right. Will probably change every day
@export var chanceOfNeedingDetained:=0.1 #percent chance of needing to be detained, only rolls if the person already shouldnt go through
@onready var interaction_component: Area3D = $InteractionComponent
var sentAway:=false
var decisionMade:=""
var thingWrong:="Hurt my\nfeelings :("

func _ready():
	var planetFile := FileAccess.open("res://data text files/planet_names.txt", FileAccess.READ)
	var content := planetFile.get_as_text()
	planetList = content.split("\n", false)  # false removes empty lines
	var speciesFile := FileAccess.open("res://data text files/species_names.txt", FileAccess.READ)
	content = speciesFile.get_as_text()
	speciesList = content.split("\n", false)  # false removes empty lines
	var nameFile := FileAccess.open("res://data text files/alien_names.txt", FileAccess.READ)
	content = nameFile.get_as_text()
	nameList = content.split("\n", false)  # false removes empty lines
	var descFile := FileAccess.open("res://data text files/species_desc.txt", FileAccess.READ)
	content = descFile.get_as_text()
	descList = content.split("\n", false)  # false removes empty lines
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
	physDesc=descList[ID]
	birthDate=str(randi_range(1000,9999))+"-"+str(randi_range(1000,9999)) #TEMPORARY, JUST ASSIGNS RANDOM NUMBERS
	passExpirDate=str(randi_range(1000,9999))+"-"+str(randi_range(1000,9999)) #TEMPORARY, JUST ASSIGNS RANDOM NUMBERS
	planetOfBirth=planetList[randi_range(0,planetList.size()-1)]
	
	destination=solarSystemPlanets[randi_range(0,solarSystemPlanets.size()-1)]
	departureLocation=planetList[randi_range(0,planetList.size()-1)]
	tripPurpose=tripPorpoises[randi_range(0,tripPorpoises.size()-1)]
	tripDate=str(randi_range(1000,9999))+"-"+str(randi_range(0,9999)) #TEMPORARY, JUST ASSIGNS RANDOM NUMBERS
	IDNumber=str(randi_range(0,9))+" "+str(randi_range(1,9))+" - "+str(randi_range(1,9))+" "+str(randi_range(1,9))+" "+str(randi_range(1,9))+" - "+str(randi_range(1,9))+" "+str(randi_range(1,9))+" "+str(randi_range(1,9))+" "+str(randi_range(1,9))
	
	trait_displayer.text="Species: "+species+"\nName: "+alName+"\nDesc: "+physDesc+"\nBirthdate: "+birthDate+"\npassExpirDate: "+passExpirDate+"\nPlanet of Origin: "+planetOfBirth+"\nDestination:"+destination+"\ndeparture loc: "+departureLocation+"\ntrip Type: "+tripType+"\ntrip Purpose: "+tripPurpose+"\ntrip Date: "+tripDate+"\nID Number: "+IDNumber+"\nIs Good to Go? "+str(shouldLetThrough)+" Should Detain? "+str(shouldDetain)


func _on_move_animator_animation_finished(anim_name: StringName) -> void:
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
					rightChoice.emit()
				elif decisionMade=="no":
					wrongChoice.emit("ERROR:\nValid Individual\nRejected")
				else:
					wrongChoice.emit("ERROR:\nValid Individual\nDetained")
			else:
				if decisionMade=="no":
					rightChoice.emit()
				elif decisionMade=="yes":
					wrongChoice.emit(thingWrong)
				else:
					wrongChoice.emit("ERROR:\nUnlawful\nDetainment")
		await get_tree().create_timer(randi_range(2,7)).timeout
		randomize_sprite()
		decisionMade=""
		move_animator.play("showUp")
		
	
