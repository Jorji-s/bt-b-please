extends CSGCombiner3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var green_component: Area3D = $greenButton/GreenComponent
@onready var red_component: Area3D = $redButton/RedComponent
@onready var detainimator: AnimationPlayer = $"../detainButton/detainimator"
@onready var alien: Node3D = $"../alien"
@onready var red_sound: AudioStreamPlayer3D = $redSound
@onready var green_sound: AudioStreamPlayer3D = $greenSound


func _on_green_component_interacted() -> void:
	if animation_player.current_animation!="pressGreen" && animation_player.current_animation!="pressRed":
		animation_player.play("pressGreen")
		green_sound.play()
		if get_parent().AlienAtCounter==true:
			alien.letThrough("yes")

func _on_red_component_interacted() -> void:
	if animation_player.current_animation!="pressGreen" && animation_player.current_animation!="pressRed":
		animation_player.play("pressRed")
		red_sound.play()
		if get_parent().AlienAtCounter==true:
			alien.letThrough("no")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name!="RESET":
		animation_player.play("RESET")
