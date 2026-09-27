extends CSGCombiner3D
@onready var green_flash: CSGBox3D = $greenFlash
@onready var red_flash: CSGBox3D = $redFlash
@onready var tv_animator: AnimationPlayer = $tvAnimator
@onready var tv_label: Label3D = $TVSCREEN/tvLabel
@onready var green_sound: AudioStreamPlayer3D = $TVSCREEN/greenSound
@onready var red_sound: AudioStreamPlayer3D = $TVSCREEN/redSound


func _ready() -> void:
	tv_label.text="Quota: "+str(get_parent().quota)+"\nServed: 0"

func updateTV()->void:
	tv_label.text="Quota: "+str(get_parent().quota)+"\nServed: 0"

func _on_alien_right_choice() -> void:
	tv_animator.play("flashGreen")
	green_sound.play()
	tv_label.visible=false


func _on_alien_wrong_choice(reason: String) -> void:
	tv_animator.play("flashRed")
	red_sound.play()
	tv_label.text=reason


func _on_tv_animator_animation_finished(anim_name: StringName) -> void:
	if anim_name!="RESET":
		get_parent().aliensServed+=1
		
	tv_label.text="Quota: "+str(get_parent().quota)+"\nServed: "+str(get_parent().aliensServed+1)
	tv_label.visible=true
	tv_animator.play("RESET")
