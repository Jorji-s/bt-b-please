extends Node3D
@onready var sprite_3d: Sprite3D = $Sprite3D
@onready var player: CharacterBody3D = $"../../player"

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	if sprite_3d!=null:
		sprite_3d.look_at(player.global_position)
		sprite_3d.rotation.x=0
		sprite_3d.rotation.z=0


func _on_interaction_component_interacted() -> void:
	player.holdingPaper=false
