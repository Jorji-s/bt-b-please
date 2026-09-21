extends CSGCombiner3D
@onready var green_flash: CSGBox3D = $greenFlash
@onready var red_flash: CSGBox3D = $redFlash
@onready var tv_animator: AnimationPlayer = $tvAnimator
@onready var tv_label: Label3D = $TVSCREEN/tvLabel


func _on_alien_right_choice() -> void:
	tv_animator.play("flashGreen")
	tv_label.visible=false


func _on_alien_wrong_choice(reason: String) -> void:
	tv_animator.play("flashRed")
	tv_label.text=reason


func _on_tv_animator_animation_finished(anim_name: StringName) -> void:
	if anim_name!="RESET":
		get_parent().aliensServed+=1
	tv_label.text="Now\nServing:\nA"+str(get_parent().aliensServed+1)
	tv_label.visible=true
	tv_animator.play("RESET")
