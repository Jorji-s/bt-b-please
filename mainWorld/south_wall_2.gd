extends CSGBox3D
@onready var door_anima: AnimationPlayer = $Node3D/doorAnima
@onready var player: CharacterBody3D = $"../../player"
@onready var marker_3d: Marker3D = $Marker3D
@onready var looker: Marker3D = $looker
@onready var final_mover: Marker3D = $finalMover
@onready var exit_interact: Area3D = $exitInteract

func _ready() -> void:
	marker_3d.global_position.y=player.global_position.y

func _on_interaction_component_interacted() -> void:
	exit_interact.global_position.y+=20
	player.allow_moving=false
	player.allow_looking=false
	var moveTween=create_tween()
	moveTween.tween_property(player,"global_position",marker_3d.global_position,0.5).set_ease(Tween.EASE_IN_OUT)
	await moveTween.finished
	door_anima.play("openDoor")
	player.betterLookAt(looker.global_position)
	await get_tree().create_timer(0.7).timeout
	var moveTween2=create_tween()
	moveTween2.tween_property(player,"global_position",final_mover.global_position,1.5).set_ease(Tween.EASE_IN_OUT)
	await moveTween2.finished
	get_tree().change_scene_to_file("res://mainWorld/postDaySummary.tscn")
	
