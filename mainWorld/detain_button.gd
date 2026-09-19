extends CSGCombiner3D
@onready var stick_note: MeshInstance3D = $stickNote
@onready var glow_button: CSGCylinder3D = $glowButton
@onready var ooo_button: CSGCylinder3D = $oooButton
@onready var interaction_component: Area3D = $InteractionComponent

func _ready() -> void:
	if Manager.detainUnlocked:
		stick_note.visible=false
		glow_button.visible=true
		interaction_component.global_position.y+=10
		ooo_button.visible=false
