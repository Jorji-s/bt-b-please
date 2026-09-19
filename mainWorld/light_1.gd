extends CSGBox3D
@onready var timer: Timer = $Timer
var flicks=0;

func _ready() -> void:
	timer.start(randf_range(120,300))

func _on_timer_timeout() -> void:
	flicks=randi_range(1,4)
	while(flicks>0):
		flicks-=1
		self.visible=false
		await get_tree().create_timer(randf_range(0.05,0.2)).timeout
		self.visible=true
		await get_tree().create_timer(randf_range(0.05,0.1)).timeout
	timer.start(randf_range(120,300))
