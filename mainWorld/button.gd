extends CSGCombiner3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var green_component: Area3D = $greenButton/GreenComponent
@onready var red_component: Area3D = $redButton/RedComponent
@onready var detainimator: AnimationPlayer = $"../detainButton/detainimator"


func _on_green_component_interacted() -> void:
	if animation_player.current_animation!="pressGreen" && animation_player.current_animation!="pressRed" && detainimator.current_animation!="press":
		animation_player.play("pressGreen")


func _on_red_component_interacted() -> void:
	if animation_player.current_animation!="pressGreen" && animation_player.current_animation!="pressRed" && detainimator.current_animation!="press":
		animation_player.play("pressRed")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name!="RESET":
		animation_player.play("RESET")
