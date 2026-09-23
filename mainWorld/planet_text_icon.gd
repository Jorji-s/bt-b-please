extends Sprite2D
@onready var plan_cover: ColorRect = $planCover
@onready var planet_list: Sprite2D = $"../planetList"
@onready var computer_obj: Node3D = $"../../../.."
@onready var wanted_list: Sprite2D = $"../wantedList"
@onready var banned_planet_list: Sprite2D = $"../bannedPlanetList"
@onready var print_menu: Sprite2D = $"../printMenu"
@onready var messages: Node2D = $"../messages"

@export var document2Open:=0



func _input(event):
	if event.is_action_pressed("Interact") && plan_cover.visible && !computer_obj.hasDocuOpen && computer_obj.onMainScreen && visible:
		if document2Open==1:
			planet_list.showDoc()
			planet_list.visible=true
			computer_obj.hasDocuOpen=true
		if document2Open==2:
			wanted_list.showDoc()
			wanted_list.visible=true
			computer_obj.hasDocuOpen=true
		if document2Open==3:
			banned_planet_list.showDoc()
			banned_planet_list.visible=true
			computer_obj.hasDocuOpen=true
		if document2Open==4:
			print_menu.showDoc()
			print_menu.visible=true
			computer_obj.hasDocuOpen=true
		if document2Open==5:
			messages.showDoc()
			messages.visible=true
			computer_obj.hasDocuOpen=true
func _on_area_2d_area_entered(area: Area2D) -> void:
	plan_cover.visible=true


func _on_area_2d_area_exited(area: Area2D) -> void:
	plan_cover.visible=false
