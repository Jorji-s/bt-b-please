extends CSGBox3D
@onready var docu_animator: AnimationPlayer = $docuAnimator
@onready var passport: Sprite3D = $passport
@onready var trip_ticket: Sprite3D = $tripTicket
@onready var interaction_component: Area3D = $tripTicket/InteractionComponent
@onready var pass_interaction_component: Area3D = $passport/passInteractionComponent
@onready var place_paper: AudioStreamPlayer3D = $placePaper
@onready var place_paper_2: AudioStreamPlayer3D = $placePaper2


func _on_alien_at_counter() -> void:
	
	docu_animator.play("placeDocuments")
	interaction_component.global_position.y+=100
	pass_interaction_component.global_position.y+=100
	passport.visible=true
	trip_ticket.visible=true
	place_paper.play()
	place_paper.pitch_scale=randf_range(0.67,0.8)
	await get_tree().create_timer(0.3).timeout
	place_paper.play()
	place_paper.pitch_scale=randf_range(0.8,1.1)
	await get_tree().create_timer(0.5).timeout
	interaction_component.global_position.y-=100
	pass_interaction_component.global_position.y-=100


func _on_alien_left_counter() -> void:
	docu_animator.play_backwards("placeDocuments")
	place_paper.play()
	place_paper.pitch_scale=randf_range(0.67,0.8)
	interaction_component.global_position.y+=100
	pass_interaction_component.global_position.y+=100
	await get_tree().create_timer(1.2).timeout
	passport.visible=false
	trip_ticket.visible=false
	pass_interaction_component.global_position.y-=100
	interaction_component.global_position.y-=100
