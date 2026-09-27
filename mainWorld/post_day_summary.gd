extends Node2D
@export var ecrimThough:=0
@export var evalidThough:=0
@export var ecrimAway:=0
@export var evalidAway:=0
@export var efalseDetains:=0
@export var emissedDetains:=0
@export var ecorrectDetains:=0
@export var etimeTaken:=0.0
@onready var good_ping: AudioStreamPlayer = $goodPing
@onready var bad_pimg: AudioStreamPlayer = $badPimg
@onready var super_bad_ping: AudioStreamPlayer = $superBadPing
@onready var very_good_ping: AudioStreamPlayer = $veryGoodPing
@onready var super_good_ping: AudioStreamPlayer = $superGoodPing

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var updated_values: Label = $ColorRect/Control/updatedValues
@onready var day_label: Label = $ColorRect/Control/dayLabel
@onready var day_label_2: Label = $ColorRect/Control/dayLabel2
@onready var rich_text_label: RichTextLabel = $ColorRect/Control/RichTextLabel
@onready var tick: AudioStreamPlayer = $tick

var totalScore:=0
var rank:=0
var multiploed:=false
var etotalscore:=0

func _ready() -> void:
	day_label.text="Day "+str(Manager.day)+" Summary"
	await get_tree().create_timer(1.0).timeout
	while(Manager.validThough>0):
		evalidThough+=1
		Manager.validThough-=1
		good_ping.play()
		totalScore+=100
		var totalTween=create_tween()
		totalTween.tween_property(self,"etotalscore",totalScore,0.3)
		await get_tree().create_timer(0.5).timeout
	
	if Manager.validAway>0:
		await get_tree().create_timer(1.0).timeout
	while(Manager.validAway>0):
		evalidAway+=1
		bad_pimg.play()
		Manager.validAway-=1
		totalScore-=150
		var totalTween=create_tween()
		totalTween.tween_property(self,"etotalscore",totalScore,0.3)
		await get_tree().create_timer(0.5).timeout
		
	if Manager.crimThough>0:
		await get_tree().create_timer(1.0).timeout
	while(Manager.crimThough>0):
		ecrimThough+=1
		bad_pimg.play()
		Manager.crimThough-=1
		totalScore-=75
		var totalTween=create_tween()
		totalTween.tween_property(self,"etotalscore",totalScore,0.3)
		await get_tree().create_timer(0.5).timeout
	if Manager.crimAway>0:
		await get_tree().create_timer(1.0).timeout
	while(Manager.crimAway>0):
		ecrimAway+=1
		good_ping.play()
		Manager.crimAway-=1
		totalScore+=50
		var totalTween=create_tween()
		totalTween.tween_property(self,"etotalscore",totalScore,0.3)
		await get_tree().create_timer(0.5).timeout
	
	if Manager.correctDetains>0:
		await get_tree().create_timer(1.0).timeout
	while(Manager.correctDetains>0):
		ecorrectDetains+=1
		very_good_ping.play()
		Manager.correctDetains-=1
		totalScore+=250
		var totalTween=create_tween()
		totalTween.tween_property(self,"etotalscore",totalScore,0.3)
		await get_tree().create_timer(0.5).timeout
	
	if Manager.missedDetains>0:
		await get_tree().create_timer(1.0).timeout
	while(Manager.missedDetains>0):
		emissedDetains+=1
		bad_pimg.play()
		Manager.missedDetains-=1
		totalScore-=500
		var totalTween=create_tween()
		totalTween.tween_property(self,"etotalscore",totalScore,0.3)
		await get_tree().create_timer(0.5).timeout
	
	if Manager.falseDetains>0:
		await get_tree().create_timer(1.0).timeout
	while(Manager.falseDetains>0):
		efalseDetains+=1
		Manager.falseDetains-=1
		totalScore-=1000
		super_bad_ping.play()
		var totalTween=create_tween()
		totalTween.tween_property(self,"etotalscore",totalScore,0.3)
		await get_tree().create_timer(0.5).timeout
	
	await get_tree().create_timer(1.0).timeout
	totalScore+=Manager.quotaRef*60*5
	tick.play()
	while(Manager.timeTaken>0):
		Manager.timeTaken-=1
		etimeTaken+=1
		totalScore-=5
		var totalTween2=create_tween()
		totalTween2.tween_property(self,"etotalscore",totalScore,0.0125)
		await get_tree().create_timer(0.025).timeout
	tick.stop()
	await get_tree().create_timer(1.0).timeout
	if totalScore<0:
		rank=1
	Manager.dayEarningMoney=totalScore
	var maxScore:=totalScore
	while totalScore>0:
		totalScore-=maxScore/100
		rank+=maxScore/100
		await get_tree().create_timer(0.005).timeout
	await get_tree().create_timer(2.0).timeout
	animation_player.play_backwards("fdeIn")
	await get_tree().create_timer(0.6).timeout
	get_tree().change_scene_to_file("res://mainWorld/totalSummary.tscn")

func _process(delta: float) -> void:	
	updated_values.text="\nValid Individuals let through: "+str(evalidThough)+" +$"+str(evalidThough*100)+"\nValid Individuals sent back: "+str(evalidAway)+" -$"+str(evalidAway*150)+"\n\nInvalid Individuals let through: "+str(ecrimThough)+" -$"+str(ecrimThough*75)+"\nInvalid Individuals sent back: "+str(ecrimAway)+" +$"+str(ecrimAway*50)+"\n\nBlacklisted Individuals detained: "+str(ecorrectDetains)+" +$"+str(ecorrectDetains*250)+"\nBlacklisted Individuals missed: "+str(emissedDetains)+" -$"+str(emissedDetains*500)+"\nNon-Blacklisted Individuals detained: "+str(efalseDetains)+" -$"+str(efalseDetains*1000)
	updated_values.text+="\n\nTime taken: "+str(int(etimeTaken/60))+":"+str(int(etimeTaken)-int(etimeTaken/60)*60).pad_zeros(2)
	if etimeTaken>Manager.quotaRef*60:
		updated_values.text+=" -$"+str(int(etimeTaken-Manager.quotaRef*60)*5)
	else:
		updated_values.text+=" +$"+str(int(Manager.quotaRef*60-etimeTaken)*5)
	updated_values.text+="\nTotal Money Earned: $"+str(etotalscore)
	
	if rank>0:
		if evalidAway==0 && ecrimThough==0 && emissedDetains==0 && efalseDetains==0 && etimeTaken<Manager.quotaRef*60:
			rich_text_label.text="Grade: [color=pink]P"
			if !multiploed:
				if super_bad_ping.volume_db!=3:
					super_bad_ping.pitch_scale=2.5
					super_bad_ping.play()
					super_bad_ping.volume_db=3
				multiploed=true
				Manager.dayEarningMoney*=2
				var totalTween2=create_tween()
				totalTween2.tween_property(self,"etotalscore",Manager.dayEarningMoney,0.5)
		else:
			if rank<10:
				rich_text_label.text="Grade: [color=brown]F"
				if super_bad_ping.volume_db!=0:
					super_bad_ping.play()
					super_bad_ping.pitch_scale=0.5
					super_bad_ping.volume_db=0
			elif rank<1000:
				rich_text_label.text="Grade: [color=blue]D"
				if bad_pimg.volume_db!=0:
					bad_pimg.play()
					bad_pimg.volume_db=0
			elif rank<2000:
				rich_text_label.text="Grade: [color=yellow]C"
				if good_ping.volume_db!=0:
					good_ping.play()
					good_ping.volume_db=0
			elif rank<3000:
				rich_text_label.text="Grade: [color=orange]B"
				if good_ping.volume_db!=1:
					good_ping.play()
					good_ping.volume_db=1
					good_ping.pitch_scale=1.25
			elif rank<4000:
				rich_text_label.text="Grade: [color=red]A"
				if very_good_ping.volume_db!=0:
					very_good_ping.play()
					very_good_ping.volume_db=0
				
			elif rank<7500:
				rich_text_label.text="Grade: [color=lime]S"
				if super_good_ping.volume_db!=0:
					super_good_ping.play()
					super_good_ping.volume_db=0
			else:
				rich_text_label.text="Grade: [color=purple]W"
				if super_bad_ping.volume_db!=3:
					super_bad_ping.pitch_scale=3.0
					super_bad_ping.play()
					super_bad_ping.volume_db=3
	elif rank<0:
		rich_text_label.text="Grade: [color=brown]F"
	
			
		
