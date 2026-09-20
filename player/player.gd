extends CharacterBody3D
@onready var neck: Node3D = $neck
@export var mouse_senX:=10.0
@export var mouse_senY:=7.0
@onready var camera_3d: Camera3D = $neck/Camera3D
@onready var pause_lab: Label = $HUD/pauseLab
@onready var pixel_shader: MeshInstance3D = $neck/Camera3D/pixelShader
@onready var interaction_ray: RayCast3D = $"neck/Camera3D/interaction ray"

@export var allow_moving:=true
@export var speed:=4.75;
@export var acceleration:=47.5
@export var allow_looking:=false
@export var paused:=false
@export var allow_interaction=true

@export var bobSpeed:=10.0
@export var bobAmount:=0.05
@export var bobReturn:=10.0
var bobTime:=0.0
var camStartPos:=Vector3.ZERO
var lastHitObject=null

func _ready() -> void:
	camStartPos=camera_3d.position
	await get_tree().create_timer(0.2).timeout
	allow_looking=true

	DialogManager.dialog_started.connect(_on_dialog_started)
	DialogManager.dialog_finished.connect(_on_dialog_finished)

func _input(event: InputEvent) -> void:
	#Pause mechanics
	# asher added: pause key is disabled if dialog manager is active
	if event.is_action_pressed("esc") and not DialogManager.is_active:
		if !paused:
			paused=true
			pause_lab.visible=true
			Input.mouse_mode=Input.MOUSE_MODE_VISIBLE
		else:
			paused=false
			pause_lab.visible=false
			Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
	
	#NECK ROTATE
	#shit was a pain in my ass btw dont confuse MOUSE_MODE_CONFINED_HIDDEN with MOUSE_MODE_CAPTURED because otherwise you will spend 45 minutes trying to figure out why the camera randomly stops turning when in reality its that the mouse is invisibly hitting the edge of the screen FML AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
	if event is InputEventMouseMotion && allow_looking && !paused:
		neck.rotate_y(-event.relative.x*0.2*get_process_delta_time()*mouse_senY/10.0)
		var pitch_rotate = neck.rotation_degrees.x - event.relative.y* mouse_senX*get_process_delta_time()
		var new_pitch = clampf(pitch_rotate,-80,80)
		neck.rotation_degrees.x=new_pitch
		
		
func _physics_process(delta: float) -> void:
	#gets direction held by keys :D
	var inputDirX = Input.get_axis("Left", "Right")
	var inputDirY = Input.get_axis("Up", "Down")
	
	#makes diagonal strafing not faster
	var inputDir = Vector2(inputDirX,inputDirY).normalized()
	var walkDir = Vector3(inputDir.x, 0, inputDir.y).rotated(Vector3.UP, neck.rotation.y)
	
	# Check if interaction ray hit something
	# Hit object should be interactable type because of collision layer
	
	if interaction_ray.is_colliding():
		var hit_object = interaction_ray.get_collider()
		hit_object.showIcon(camera_3d)
		lastHitObject=hit_object
	else:
		if lastHitObject!=null:
			lastHitObject.hideIcon()
			lastHitObject=null
		
	if interaction_ray.is_colliding() and Input.is_action_just_pressed("Interact") and allow_interaction:
		var hit_object = interaction_ray.get_collider()
		hit_object.interact()
		
	#Cool epic acceleration based movement that feels silky smooth both starting and stopping mmmmm
	if allow_moving && !paused:
		var target_velocity = walkDir * speed
		velocity.x = move_toward(velocity.x,target_velocity.x,acceleration * delta)
		velocity.z = move_toward(velocity.z,target_velocity.z,acceleration * delta)

		#cool epic view bobbing yummers
		if walkDir!=Vector3.ZERO:
			bobTime += delta * bobSpeed
			camera_3d.position.y = camStartPos.y + sin(bobTime) * bobAmount
			camera_3d.position.x = camStartPos.x + cos(bobTime * 0.5) * bobAmount * 0.5
		else:
			bobTime=0.0
			camera_3d.position.y = lerpf(camera_3d.position.y,camStartPos.y,delta * bobReturn)
			camera_3d.position.x = lerpf(camera_3d.position.x,camStartPos.x,delta * bobReturn)
	else:
		velocity.x = move_toward(velocity.x,0,acceleration * delta)
		velocity.z = move_toward(velocity.z,0,acceleration * delta)
	
	move_and_slide()

# Disable looking and moving during dialog
func _on_dialog_started(_lines : Array[String]):
	allow_looking = false
	allow_moving = false
	allow_interaction = false
	Input.mouse_mode=Input.MOUSE_MODE_VISIBLE

	
# Reenable looking and moving after dialog completion
func _on_dialog_finished():
	allow_looking = true
	allow_moving = true
	allow_interaction = true
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
