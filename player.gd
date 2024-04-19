extends CharacterBody3D


const SPEED = 15.0
const ACCEL = 40.0
@onready var cam = $Camera3D


func _ready():
	cam.current = is_multiplayer_authority()


func _physics_process(delta):
	if !is_multiplayer_authority():
		return
	
	var Vy = velocity.y
	velocity.y = 0
	var input = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	var dir = Vector3(input.x,0,input.y)
	velocity = lerp(velocity, dir * SPEED, ACCEL * delta)
	velocity.y = Vy
	
	move_and_slide()
