extends CSGBox3D
@onready var docu_animator: AnimationPlayer = $docuAnimator
@onready var passport: Sprite3D = $passport
@onready var trip_ticket: Sprite3D = $tripTicket
@onready var interaction_component: Area3D = $tripTicket/InteractionComponent
@onready var pass_interaction_component: Area3D = $passport/passInteractionComponent


func _on_alien_at_counter() -> void:
	docu_animator.play("placeDocuments")
	interaction_component.global_position.y+=100
	pass_interaction_component.global_position.y+=100
	passport.visible=true
	trip_ticket.visible=true
	await get_tree().create_timer(0.8).timeout
	interaction_component.global_position.y-=100
	pass_interaction_component.global_position.y-=100


func _on_alien_left_counter() -> void:
	docu_animator.play_backwards("placeDocuments")
	interaction_component.global_position.y+=100
	pass_interaction_component.global_position.y+=100
	await get_tree().create_timer(1.2).timeout
	passport.visible=false
	trip_ticket.visible=false
	pass_interaction_component.global_position.y-=100
	interaction_component.global_position.y-=100
