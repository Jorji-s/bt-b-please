extends AudioStreamPlayer3D
@onready var audio_stream_player_3: AudioStreamPlayer3D = $"."
@onready var ominousx_ambi_timer: Timer = $ominousxAmbiTimer


func _on_ominousx_ambi_timer_timeout() -> void:
	audio_stream_player_3.play()
	ominousx_ambi_timer.start(randf_range(10,20))
