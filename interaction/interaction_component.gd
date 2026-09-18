# Author: asher
# Just add this component as a child of whatever you want to be interactable
# Then connect the interacted signal to your script
# Scale the component to your desired size
# Enjoy!
extends Area3D

signal interacted

func interact():
	emit_signal("interacted")
