extends Control
@onready var alien: Node3D = $"../../alien"
@onready var name_label: Label = $passport/nameLabel
@onready var species_label: Label = $passport/speciesLabel
@onready var planet_label: Label = $passport/planetLabel
@onready var desc_label: Label = $passport/descLabel
@onready var birth_label: Label = $passport/birthLabel
@onready var expir_date: Label = $passport/expirDate
@onready var passport: Sprite2D = $passport
@onready var player: CharacterBody3D = $"../../player"
@onready var docu_hud_animator: AnimationPlayer = $docuHudAnimator


@onready var name_label_2: Label = $travelCard/nameLabel2
@onready var species_label_2: Label = $travelCard/speciesLabel2
@onready var id_num_lab: Label = $travelCard/IDNumLab
@onready var date_label: Label = $travelCard/dateLabel
@onready var trip_label: Label = $travelCard/tripLabel
@onready var desc_label_2: Label = $travelCard/descLabel2

var passOpen:=false
var tickOpen:=false

func updateLabels()->void:
	name_label.text="Name -\n"+alien.alName
	species_label.text="Species -\n"+alien.species
	planet_label.text="Home Planet -\n"+alien.planetOfBirth
	desc_label.text="Description -\n"+alien.physDesc
	birth_label.text="DOB - "+alien.birthDate
	expir_date.text="Expires\n"+alien.passExpirDate
	
	name_label_2.text="Name - "+alien.alName
	species_label_2.text="Species - "+alien.species
	id_num_lab.text="ID - "+alien.IDNumber
	trip_label.text="Trip Date "+get_parent().get_parent().currentDate
	trip_label.text=alien.departureLocation+" -> "+alien.destination
	desc_label_2.text="Description - "+alien.physDesc


func _on_pass_interaction_component_interacted() -> void:
	if !tickOpen:
		if docu_hud_animator.current_animation!="showPassport" && get_parent().get_parent().AlienAtCounter:
			if player.allow_moving:
				docu_hud_animator.play("showPassport")
				passOpen=true
				player.allow_moving=false
				player.allow_looking=false
			else:
				docu_hud_animator.play_backwards("showPassport")
				player.allow_moving=true
				player.allow_looking=true
				await get_tree().create_timer(0.5).timeout
				passOpen=false


func _on_interaction_component_interacted() -> void:
	if !passOpen:
		if docu_hud_animator.current_animation!="showTicket" && get_parent().get_parent().AlienAtCounter:
			if player.allow_moving:
				docu_hud_animator.play("showTicket")
				tickOpen=true
				player.allow_moving=false
				player.allow_looking=false
			else:
				docu_hud_animator.play_backwards("showTicket")
				player.allow_moving=true
				player.allow_looking=true
				await get_tree().create_timer(0.5).timeout
				tickOpen=false
