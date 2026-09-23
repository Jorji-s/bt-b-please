extends CSGBox3D
@onready var timer: Timer = $Timer
var flicks=0;

func _ready() -> void:
	if Manager.day>13:
		timer.start(randf_range(1,10))
	elif Manager.day>8:
		timer.start(randf_range(60,120))
	else:
		timer.start(randf_range(120,300))

func _on_timer_timeout() -> void:
	if Manager.day>13:
		flicks=randi_range(4,10)
	elif Manager.day>8:
		flicks=randi_range(1,6)
	else:
		flicks=randi_range(1,4)
	
	while(flicks>0):
		flicks-=1
		self.visible=false
		if Manager.day>13:
			await get_tree().create_timer(randf_range(0.05,0.5)).timeout
		else:
			await get_tree().create_timer(randf_range(0.05,0.2)).timeout
		self.visible=true
		await get_tree().create_timer(randf_range(0.05,0.1)).timeout
	if Manager.day>13:
		timer.start(randf_range(15,30))
	elif Manager.day>8:
		timer.start(randf_range(60,120))
	else:
		timer.start(randf_range(120,300))
