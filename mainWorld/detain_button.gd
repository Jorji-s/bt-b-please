extends CSGCombiner3D
@onready var stick_note: MeshInstance3D = $stickNote
@onready var glow_button: CSGCylinder3D = $glowButton
@onready var ooo_button: CSGCylinder3D = $oooButton
@onready var interaction_component: Area3D = $InteractionComponent
@onready var detainimator: AnimationPlayer = $detainimator
@onready var animation_player: AnimationPlayer = $"../button/AnimationPlayer"
@onready var docu_animator: AnimationPlayer = $"../tempRoom/North Wall/counterTop/docuAnimator"
@onready var alien: Node3D = $"../alien"

func _ready() -> void:
	if Manager.detainUnlocked:
		stick_note.visible=false
		glow_button.visible=true
		interaction_component.global_position.y+=10
		ooo_button.visible=false


func _on_interaction_component_interacted() -> void:
	if detainimator.current_animation!="press" && animation_player.current_animation!="pressGreen" && animation_player.current_animation!="pressRed" && get_parent().AlienAtCounter==true:
		detainimator.play("press")
		alien.letThrough("detain")
