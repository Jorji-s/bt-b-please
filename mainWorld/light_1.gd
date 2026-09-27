extends CSGBox3D
@onready var timer: Timer = $Timer
var flicks=0;
@onready var light_container: Node3D = $".."
@onready var spot_light_3d_2: SpotLight3D = $SpotLight3D2
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D

func _process(delta: float) -> void:
	if light_container.visible==false:
		if audio_stream_player_3d.volume_db>-100:
			audio_stream_player_3d.volume_db=-100
	else:
		if audio_stream_player_3d.volume_db<-99:
			audio_stream_player_3d.volume_db=-2

func _ready() -> void:
	if Manager.day>13:
		timer.start(randf_range(1,30))
	elif Manager.day>8:
		timer.start(randf_range(60,120))
	else:
		timer.start(randf_range(120,300))

func _on_timer_timeout() -> void:
	if Manager.day>13:
		flicks=randi_range(2,5)
	elif Manager.day>8:
		flicks=randi_range(1,6)
	else:
		flicks=randi_range(1,4)
	
	while(flicks>0):
		flicks-=1
		audio_stream_player_3d.volume_db=-80
		self.visible=false
		if Manager.day>13:
			await get_tree().create_timer(randf_range(0.05,0.5)).timeout
		else:
			await get_tree().create_timer(randf_range(0.05,0.2)).timeout
		self.visible=true
		audio_stream_player_3d.volume_db=-2
		await get_tree().create_timer(randf_range(0.05,0.1)).timeout
	if Manager.day>13:
		timer.start(randf_range(15,30))
	elif Manager.day>8:
		timer.start(randf_range(60,120))
	else:
		timer.start(randf_range(120,300))
