extends Node3D
@onready var player: CharacterBody3D = $"../../player"
@onready var sprite_3d: AnimatedSprite3D = $Sprite3D
func _process(delta: float) -> void:
	if sprite_3d!=null:
		sprite_3d.look_at(player.global_position)
		sprite_3d.rotation.x=0
		sprite_3d.rotation.z=0
