extends Node3D

@onready var game_button: Sprite2D = $Control2/Node2D/gameButton
@onready var credit_button: Sprite2D = $Control2/Node2D/creditButton
@onready var exitbutton: Sprite2D = $Control2/Node2D/exitbutton
@onready var cursor: Area2D = $cursor
var hoved:=0
var changing:=false
var playingCredits:=false
@onready var credits_label: Label = $Control2/creditsLabel
@onready var animation_player: AnimationPlayer = $ColorRect/AnimationPlayer

func _process(delta: float) -> void:
	cursor.global_position=get_viewport().get_mouse_position()
	if playingCredits:
		credits_label.global_position.y-=100*delta
	if Input.is_action_just_pressed("Interact"):
		if hoved==1 && !changing:
			changing=true
			animation_player.play_backwards("fade")
			await get_tree().create_timer(0.6).timeout
			get_tree().change_scene_to_file("res://mainWorld/main_world.tscn")
		if hoved==2 && !changing:
			if !playingCredits:
				playingCredits=true
				credits_label.global_position.y=1120.0
				await get_tree().create_timer(60.0).timeout
				playingCredits=false
		if hoved==3 && !changing:
			changing=true
			animation_player.play_backwards("fade")
			await get_tree().create_timer(0.6).timeout
			get_tree().quit()

	


func _on_new_game_area_entered(area: Area2D) -> void:
	hoved=1
	var growTween=create_tween()
	growTween.tween_property(game_button,'scale',Vector2(1.15,1.15),0.25).set_ease(Tween.EASE_IN_OUT)
	growTween.tween_property(game_button,'modulate',Color(1.0, 1.0, 1.0, 1.0),0.05).set_ease(Tween.EASE_IN_OUT)


func _on_new_game_area_exited(area: Area2D) -> void:
	hoved=0
	if game_button.scale.x>1:
		var growTween=create_tween()
		growTween.tween_property(game_button,'scale',Vector2(1,1),0.25).set_ease(Tween.EASE_IN_OUT)
		growTween.tween_property(game_button,'modulate',Color(0.765, 0.765, 0.765, 1.0),0.15).set_ease(Tween.EASE_IN_OUT)
	if exitbutton.scale.x>1:
		var growTween2=create_tween()
		growTween2.tween_property(exitbutton,'scale',Vector2(1,1),0.25).set_ease(Tween.EASE_IN_OUT)
		growTween2.tween_property(exitbutton,'modulate',Color(0.765, 0.765, 0.765, 1.0),0.15).set_ease(Tween.EASE_IN_OUT)
	if credit_button.scale.x>1:
		var growTween3=create_tween()
		growTween3.tween_property(credit_button,'scale',Vector2(1,1),0.25).set_ease(Tween.EASE_IN_OUT)
		growTween3.tween_property(credit_button,'modulate',Color(0.765, 0.765, 0.765, 1.0),0.15).set_ease(Tween.EASE_IN_OUT)


func _on_credits_area_entered(area: Area2D) -> void:
	hoved=2
	var growTween=create_tween()
	growTween.tween_property(credit_button,'scale',Vector2(1.15,1.15),0.25).set_ease(Tween.EASE_IN_OUT)
	growTween.tween_property(credit_button,'modulate',Color(1.0, 1.0, 1.0, 1.0),0.05).set_ease(Tween.EASE_IN_OUT)


func _on_exit_area_entered(area: Area2D) -> void:
	hoved=3
	var growTween=create_tween()
	growTween.tween_property(exitbutton,'scale',Vector2(1.15,1.15),0.25).set_ease(Tween.EASE_IN_OUT)
	growTween.tween_property(exitbutton,'modulate',Color(1.0, 1.0, 1.0, 1.0),0.05).set_ease(Tween.EASE_IN_OUT)
