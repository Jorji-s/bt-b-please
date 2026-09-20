# Author: asher
extends Node3D
@onready var modulator: Sprite3D = $modulator
@onready var human_guy: Sprite3D = $modulator/humanGuy
@onready var test_alien_1: Sprite3D = $modulator/testAlien1
@onready var trait_displayer: Label3D = $traitDisplayer

var planetList:=[]
var speciesList:=[]
var nameList:=[]
var descList:=[]
var solarSystemPlanets:=["Mercury","Venus","Earth","Mars","Jupiter","Saturn","Uranus","Neptune","Pluto","Europa"]
var tripStypes:=["One-way","Two-way","Connection"]
var tripPorpoises=["Business","Vacation","Meeting family","Pleasure ;)","Displeasure","Religious pilgrimage","Religious reasons","Seeking asylum","Immigrating","Death of a loved one","Marriage","To meet a friend"]

@onready var sprite_list = modulator.get_children()
@onready var num_sprites = sprite_list.size()
@onready var display_sprite = sprite_list[0]
@export var shouldLetThrough:=false
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
	display_sprite.visible = false
	var selector = randi_range(0,num_sprites - 1)
	alienID=selector
	display_sprite = sprite_list[selector]
	display_sprite.visible = true
	shouldLetThrough=randf_range(0,1)<chanceOfBeingRight
	assignTraits(alienID)

# Utility function to hide all the child sprites of modulator
func hide_sprites():
	for sprite in sprite_list:
		sprite.visible = false


func assignTraits(ID):
	species=speciesList[ID]
	alName=nameList[randi_range(0,nameList.size()-1)]+" "+nameList[randi_range(0,nameList.size()-1)]
	physDesc=descList[ID]
	birthDate=str(randi_range(1000,9999))+"-"+str(randi_range(1000,9999)) #TEMPORARY, JUST ASSIGNS RANDOM NUMBERS
	passExpirDate=str(randi_range(1000,9999))+"-"+str(randi_range(1000,9999)) #TEMPORARY, JUST ASSIGNS RANDOM NUMBERS
	planetOfBirth=planetList[randi_range(0,planetList.size()-1)]
	
	destination=solarSystemPlanets[randi_range(0,solarSystemPlanets.size()-1)]
	departureLocation=planetList[randi_range(0,planetList.size()-1)]
	tripType=tripStypes[randi_range(0,tripStypes.size()-1)]
	tripPurpose=tripPorpoises[randi_range(0,tripPorpoises.size()-1)]
	tripDate=str(randi_range(1000,9999))+"-"+str(randi_range(0,9999)) #TEMPORARY, JUST ASSIGNS RANDOM NUMBERS
	IDNumber=str(randi_range(10,99))+"-"+str(randi_range(100,999))+"-"+str(randi_range(1000,9999)) #TEMPORARY, JUST ASSIGNS RANDOM NUMBERS
	
	trait_displayer.text="Species: "+species+"\nName: "+alName+"\nDesc: "+physDesc+"\nBirthdate: "+birthDate+"\npassExpirDate: "+passExpirDate+"\nPlanet of Origin: "+planetOfBirth+"\nDestination:"+destination+"\ndeparture loc: "+departureLocation+"\ntrip Type: "+tripType+"\ntrip Purpose: "+tripPurpose+"\ntrip Date: "+tripDate+"\nID Number: "+IDNumber+"\nIs Good to Go? "+str(shouldLetThrough)
