extends CSGCombiner3D
@onready var stick_note: MeshInstance3D = $stickNote
@onready var glow_button: CSGCylinder3D = $glowButton
@onready var ooo_button: CSGCylinder3D = $oooButton

func _ready() -> void:
	if Manager.detainUnlocked:
		stick_note.visible=false
		glow_button.visible=true
		ooo_button.visible=false
