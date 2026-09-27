extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _process(delta: float) -> void:
	if Input.is_action_pressed("Interact"):
		animation_player.speed_scale=100


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name!="FADEoUT":
		animation_player.speed_scale=1
		animation_player.play("FADEoUT")
		await get_tree().create_timer(1.1*animation_player.speed_scale).timeout
		get_tree().change_scene_to_file("res://mainWorld/main_world.tscn")
