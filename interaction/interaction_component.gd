# Author: asher
# Just add this component as a child of whatever you want to be interactable
# Then connect the interacted signal to your script
# Scale the component to your desired size
# Enjoy!
extends Area3D
@onready var player_tracker: Node3D = $playerTracker
@onready var sprite_3d: Sprite3D = $playerTracker/Sprite3D
var player=null

signal interacted

func interact():
	emit_signal("interacted")

func _process(delta: float) -> void:
	if player!=null:
		player_tracker.look_at(player.global_transform.origin, Vector3.UP)
		sprite_3d.rotate_z(deg_to_rad(90 * delta))
func showIcon(person : Camera3D):
	sprite_3d.visible=true
	player=person
	print(player)

func hideIcon():
	print("HIDDEN")
	sprite_3d.visible=false
	player=null
