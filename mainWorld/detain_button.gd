extends CSGCombiner3D
@onready var stick_note: MeshInstance3D = $stickNote
@onready var glow_button: CSGCylinder3D = $glowButton
@onready var ooo_button: CSGCylinder3D = $oooButton
@onready var interaction_component: Area3D = $InteractionComponent
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	if Manager.detainUnlocked:
		stick_note.visible=false
		glow_button.visible=true
		interaction_component.global_position.y+=10
		ooo_button.visible=false


func _on_interaction_component_interacted() -> void:
	if animation_player.current_animation!="press":
		animation_player.play("press")
